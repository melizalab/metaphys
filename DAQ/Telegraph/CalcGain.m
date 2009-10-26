function [in_gain out_gain] = CalcGain(inst_type, in_units, out_units, voltage)
%
% CALCGAIN  Omnibus function for determining the input and output gain
% based on instrument mode.
%
% [in_gain out_gain] = CALCGAIN(instrument_type, in_units, out_units,
% voltage) returns the units associated with these units on <instrument_type>
%
% Currently supported instrument types:
%
%   '200x'  - Axon 200x series
%   '1x'    - Axon 1x   series
%
% The default value (if the gain cannot be determined) is 1
%
% Note that the gain values returned are INSTRUMENT gains: i.e. <gain>
% V/Units. When setting DAQ gains, make sure to invert this value to get
% Units/V
%
% See also: GETCHANNELGAIN, SETCHANNELGAIN
%
% $Id: CalcGain.m,v 1.2 2006/01/31 23:06:13 meliza Exp $

in_gain    = 1;
out_gain   = 1;

switch lower(inst_type)
    case '200x'
        V           = round(voltage ./ 0.5);
        gains       = [0.5 1 2 5 10 20 50 100 200 500];
        voltages    = 4:13; % doubled voltages
        ind         = (voltages == V);
        if any(ind)
            out_gain = gains(ind);
        end
        switch out_units
            case 'pA'
                out_gain        = out_gain ./ 1000;
            case 'mV' %nati
                out_gain        = out_gain ./ 1000; %nati
                
        end
        switch in_units
            case 'mV'
                in_gain           = 1/20;
            case 'nA'
                in_gain           = 1/2;
        end
    case '1x'
        V           = round(abs(voltage) ./ 0.4);
        gains       = [0.5 1 2 5 10 20 50 100];
        voltages    = 1:8;
        ind         = (voltages == V);
        if any(ind)
            out_gain = gains(ind);
        end

        % check these values
        switch lower(in_units)
            case 'mv'
                in_gain  = 1/20;
            case 'pa'
                in_gain  = 1/2000;
            case 'na'
                in_gain  = 1/2;
        end
        switch lower(out_units)
            case 'mv'
                out_gain = out_gain .* 10;
            case 'pa'
                out_gain = out_gain ./ 1000;
        end
        if voltage < 0
            out_gain = out_gain * 100;
        end
    otherwise
        warning('METAPHYS:calcmode:unknownInstrumentType',...
            'Gain telegraph not defined for instrument type %s.', inst_type)
end