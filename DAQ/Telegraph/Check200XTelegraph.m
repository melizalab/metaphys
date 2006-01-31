function results = Check200XTelegraph(instrument, object, channels)
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
% $Id: Check200XTelegraph.m,v 1.6 2006/01/31 20:00:19 meliza Exp $

%% Retrieve voltages
voltages    = CheckAnalogTelegraph(instrument, object);
if isempty(voltages)
    results = [];
    return
end

%% Determine instrument state
mode    = calcmode(voltages(2));
[in_units out_units]  = calcunits(mode);
[out_gain]            = calcgain(voltages(1));
switch in_units
    case 'mV'
        in_gain           = 20;
    case 'nA'
        in_gain           = 2;
    otherwise
        in_gain           = 1;
end

results = struct('instrument',instrument,...
                 'channel', channels,...
                 'out_units', out_units,...
                 'out_gain', out_gain,...
                 'in_units', in_units,...
                 'in_gain', in_gain);

% results = telegraphresults_struct(instrument, ...
%                                   channels, ...
%                                   out_gain, ...
%                                   out_units, ...
%                                   in_gain, ...
%                                   in_units);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_gain] = calcgain(gainVoltage)
% Voltages on the gain telegraph go up by steps of 0.5 V, so we double the
% value of the telegraph, round it, and use that as an index into the gain
% table.
try
    V = round(gainVoltage ./ 0.5);
    gains = [0.5 1 2 5 10 20 50 100 200 500];
    voltages = 4:13; % doubled voltages
    ind = (voltages == V);
    if ~any(ind)
        out_gain = 1;
    else
        out_gain = 1000 ./ gains(ind);
    end
catch
    out_gain = 1;
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
function [in_units out_units] = calcunits(mode)
%returns the units appropriate to the given mode
switch mode
case {'Fast Iclamp', 'IClamp', 'I=0'}
    in_units    = 'nA';
    out_units   = 'mV';
case {'VClamp', 'Track'}
    in_units    = 'mV';
    out_units   = 'pA';
otherwise
    in_units    = 'V';
    out_units   = 'V';
end
