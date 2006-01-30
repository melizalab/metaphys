function results = Check200XTelegraph(instrument, object, scaled_out)
%
% CHECK200XTELEGRAPH Checks the telegraph values on a 200-series Axon
% amplifier. 
%
% This amplifier has telegraphs for mode and gain; this function
% will read in the voltage values and return a structure with the
% appropriate gain, mode and units.
%
% results = CHECK200XTELEGRAPH(instrument, object)
%
% Returns the gain, mode, and units associated with the telegraphs on the
% instrument. OBJECT must be a 2x1 array of aichannel objects.
%
% The lookup tables for the telegraphs are:
%
% Gains: [0.5   1  2   5 10  20 50 100 200 500]
% Volts: [  2 2.5  3 3.5  4 4.5  5 5.5   6 6.5]
%
% Volts/Modes:
% 1: 'Fast Iclamp'
% 2: 'IClamp'
% 3: 'I=0'
% 4: 'Track'
% 5: 'VClamp'
% 
% In voltage output modes the base scaling is 1 mV/mV; in current modes the
% scaling is 1 pA/mV.
%
% See also: UPDATETELEGRAPH, ADDINSTRUMENTTELEGRAPH
%
% $Id: Check200XTelegraph.m,v 1.5 2006/01/31 00:26:02 meliza Exp $

%% Retrieve voltages
voltages    = CheckAnalogTelegraph(instrument, object);
if isempty(voltages)
    results = [];
    return
end

%% Determine instrument state
mode    = calcmode(voltages(2));
units   = calcunits(mode);
gain    = calcgain(voltages(1));


results = struct('instrument',instrument,...
                 'channel',scaled_out,...
                 'mode', mode,...
                 'units', units,...
                 'gain', gain);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = calcgain(gainVoltage)
% Voltages on the gain telegraph go up by steps of 0.5 V, so we double the
% value of the telegraph, round it, and use that as an index into the gain
% table.
try
    V = round(gainVoltage ./ 0.5);
    gains = [0.5 1 2 5 10 20 50 100 200 500];
    voltages = 4:13; % doubled voltages
    ind = (voltages == V);
    if ~any(ind)
        out = 1;
    else
        out = 1000 ./ gains(ind);
    end
catch
    out = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = calcmode(modeVoltage)

try
    V = round(modeVoltage);
    modes = {'Fast Iclamp', 'IClamp', 'I=0', 'Track', 'VClamp'};
    voltages = [1 2 3 4 6];
    i = find(voltages == V);
    if (isempty(i))
        out = 'Unknown';
    else
        out = modes{i};
    end
catch
    out = 'Unknown';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = calcunits(mode)
%returns the units appropriate to the given mode
switch mode
case {'Fast Iclamp', 'IClamp', 'I=0'}
    out = 'mV';
case {'VClamp', 'Track'}
    out = 'pA';
otherwise
    out = 'V';
end
