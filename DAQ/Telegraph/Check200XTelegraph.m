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
% $Id: Check200XTelegraph.m,v 1.7 2006/01/31 22:48:22 meliza Exp $

INST_TYPE   = '200x';

%% Retrieve voltages
voltages    = CheckAnalogTelegraph(instrument, object);
if isempty(voltages)
    results = [];
    return
end

%% Determine instrument state
mode                  = CalcMode(INST_TYPE, voltages(2));
[in_units out_units]  = CalcUnits(INST_TYPE, mode);
[in_gain out_gain]    = CalcGain(INST_TYPE, in_units, out_units, voltages(1));

results = struct('instrument',instrument,...
                 'channel', channels,...
                 'out_units', out_units,...
                 'out_gain', out_gain,...
                 'in_units', in_units,...
                 'in_gain', in_gain);
