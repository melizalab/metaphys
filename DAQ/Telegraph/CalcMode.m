function mode   = CalcMode(inst_type, voltage)
%
% CALCMODE  Omnibus function for determining the mode from telegraph
% voltages
%
% M = CALCMODE(instrument_type, mode_voltage) returns the mode associated
% with <mode_voltage> on <instrument_type>
%
% Currently supported instrument types:
%
%   '200x'  - Axon 200x series
%   '1x'    - Axon 1x   series (no mode telegraph, returns default)
%
% The default value (if the mode cannot be determined) is []
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

mode    = [];
switch lower(inst_type)
    case '200x'
        V           = round(voltage);
        modes       = {'Fast Iclamp', 'IClamp', 'I=0', 'Track', 'VClamp'};
        voltages    = [1 2 3 4 6];
        i = voltages == V;
        if any(i)
            mode    = modes{i};
        end
    case '1x'
    otherwise
        warning('METAPHYS:calcmode:unknownInstrumentType',...
            'Mode telegraph not defined for instrument type %s.', inst_type)
end
