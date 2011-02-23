function [in_units out_units]   = CalcUnits(inst_type, mode)
%
% CALCUNITS  Omnibus function for determining the input and output units
% based on instrument mode.
%
% [in_units out_units] = CALCUNITS(instrument_type, mode) returns the units
% associated with mode on <instrument_type>
%
% Currently supported instrument types:
%
%   '200x'  - Axon 200x series
%   '1x'    - Axon 1x   series (no mode telegraph, returns default)
%
% The default value (if the mode cannot be determined) is 'V'
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

in_units    = 'V';
out_units   = 'V';
if isempty(mode)
    return
end

switch lower(inst_type)
    case '200x'
        switch mode
            case {'Fast Iclamp', 'IClamp', 'I=0'}
                in_units    = 'nA';
                out_units   = 'mV';
            case {'VClamp', 'Track'}
                in_units    = 'mV';
                out_units   = 'pA';
        end
    case '1x'
    otherwise
        warning('METAPHYS:calcmode:unknownInstrumentType',...
            'Units/mode not defined for instrument type %s.', inst_type)
end
