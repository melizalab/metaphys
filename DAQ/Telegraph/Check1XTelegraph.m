function results = Check1XTelegraph(instrument, object, scaled_out)
%
% CHECK1XTELEGRAPH Checks the telegraph values on a 1-series Axon
% amplifier. 
%
% This amplifier has a telegraph for gain; this function
% will read in the voltage value and return a structure with the
% appropriate gain.
%
% results = CHECK1XTELEGRAPH(instrument, object, channels)
%
% Returns the gain associated with the telegraph on the
% instrument. OBJECT must be a single aichannel object. CHANNELS is a
% string or cell array with the names of the channels that are referred to
% by the telegraph. With this amplifier it's nice to create two
% instrumentoutputs for the scaled output, one for v-clamp and one for
% i-clamp.
%
% The lookup table for the telegraph is:
%
% Gains: [0.5   1   2   5  10  20  50 100]
% Volts: [0.4 0.8 1.2 1.6 2.0 2.4 2.8 3.2]
%
% If the beta switch is set to 100, these values are negative.
%
% In addition, the base scaling is different in voltage and current modes.
% In voltage modes the base scaling is 10 mV/mV, in current modes this is
% controlled by the beta switch
%
% See Also: UPDATETELEGRAPH, ADDINSTRUMENTTELEGRAPH
%
% $Id: Check1XTelegraph.m,v 1.1 2006/01/10 20:59:51 meliza Exp $

% Retrieve voltages
voltages    = CheckAnalogTelegraph(instrument, object);

% Determining the gain depends on the current mode of the amplifier. We
% don't have access to that, so we have to use the units that the user set
% on the scaled output.
chan        = GetInstrumentChannel(instrument, scaled_out);
units       = get(chan,'Units');        % this might be a cell array

% Determine instrument state
if iscell(units)
    gain    = ones(size(units));
    for i = 1:length(units)
        gain(i)        = calcgain(voltages(1), units{i});
    end
else
    gain               = calcgain(voltages(1), units);
end

results = struct('units', units,...
                 'gain', gain);
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = calcgain(gainVoltage, units)
% The telegraph values go up by increments of ~ 0.4
% If it's negative, add a factor of 100
% If the units are mV, add a factor of 10
V = round(abs(gainVoltage) ./ 0.4);
gains = [0.5 1 2 5 10 20 50 100];
voltages = 1:8;
ind = (voltages == V);
if ~any(ind)
    out = 1;
else
    out = gains(ind);
end

if strcmpi(units,'mv')
    out = out * 10;
elseif gainVoltage < 0
    out = out * 100;
end