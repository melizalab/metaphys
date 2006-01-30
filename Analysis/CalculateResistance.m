function [Rt, Ri] = CalculateResistance(time, data, pulse, mode, handle)
%
% CALCULATERESISTANCE Calculates the resistance of a voltage or current
% pulse
%
% [Rt, Ri] = CALCULATERESISTANCE(time, data, pulse, 'vpulse')
%
% [Rt, Ri] = CALCULATERESISTANCE(time, data, pulse, 'ipulse')
%
% Calculates the resistance of a circuit based on its response to a voltage
% or current pulse. The pulse can be positive or negative.
%
% Theory: according to Ohm's law, V = IR, or in the instantaneous case, 
% dV = dI*R.  Most circuits also have some impedance which leads to a
% relaxation from an intial transient state to a steady state, so it is
% common to calculate Rt, the transient resistance, and Ri, the input or
% steady state resistance.
%
% For a current pulse, Rt will be the instantaneous slope of the voltage
% trace at the moment the current pulse begins, and Ri the difference in
% voltages divided by the differences in current. For voltage pulses (which 
% require some sort of clamping amplifier), Rt is commonly calculated from
% the size of the current transient that results from amplifier overshoot,
% and Rs from the steady state difference in the holding currents at the
% two voltages.
%
% In both cases, the difficulty is in rapidly determining, under noisy
% conditions, where the transient occurs. The standard way of detecting
% edges is with differentiation, but this becomes problematic with high
% frequency noise, especially with pulses in current mode, since these lack
% the sharp edge of pulses in voltage clamp. Filtering is not really an
% option, due to the computational (i.e. time) costs, so we opt for speed
% over correctness and just use differentiation.
%
% $Id: CalculateResistance.m,v 1.2 2006/01/30 20:04:36 meliza Exp $

% For current pulses, what we should try to do is find the two major modes of the signal distribution
% and set a threshhold. This is a pain in the arse which is left as an
% exercise to the reader.

% There is also an undocumented feature which is useful for debugging. Pass
% the function an axes handle and it will plot where it thinks things are
% happening.

INTEGRATE   = 100;  % (samples)
GAP         = 4;    % (samples)

%% Correct for negative pulses
if pulse < 0
    pulse    = -pulse;
    data    = -data;
end

% derivative method
ord         = 1;
dd          = [diff(data(INTEGRATE+GAP:end),ord); zeros(ord,1)];
[m, transu] = max(dd);
transu      = transu  + INTEGRATE + GAP;
[m, transd] = min(dd);
transd      = transd + INTEGRATE + GAP;

ind_base    = (transu-INTEGRATE):(transu-GAP);
ind_step    = (transd-INTEGRATE):(transd-GAP);


m_base      = mean(data(ind_base));
m_step      = mean(data(ind_step));

switch mode
    case 'ipulse'
        ind_trans   = (transu+GAP):(transu+GAP+GAP);
        m_trans     = mean(data(ind_trans));
        Ri  = (m_step - m_base)./pulse;
        Rt  = (m_trans - m_base)./pulse;
    case 'vpulse'
        ind_trans   = (transu):(transu+GAP);
        m_trans     = mean(data(ind_trans));
        Ri  = pulse./(m_step - m_base);
        Rt  = pulse./(m_trans - m_base);
end

if nargin > 4
    axstate = get(handle,'nextplot');
    set(handle,'nextplot','add');
    plot(handle,time(ind_base), repmat(m_base,size(ind_base)),'r');
    plot(handle,time(ind_step), repmat(m_step,size(ind_step)),'r');
    plot(handle,time(ind_trans), repmat(m_trans,size(ind_trans)),'r');
    set(gca,'nextplot',axstate);
end
