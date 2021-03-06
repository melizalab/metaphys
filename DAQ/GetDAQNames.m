function daqs   = GetDAQNames(type)
%
% GETDAQNAMES Returns a cell array containing a list of the initialized
% daq objects stored in the control structure.
%
% daqs = GETDAQNAMES returns all the daq objects in the control structure
% daqs = GETDAQNAMES(type) returns only the daq objects of the type
% specified, which can be 'analoginput', 'analogoutput', or 'digitialio'
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
global mpctrl

if isempty(mpctrl.daq)
    daqs    = [];
    return
else
    daqs    = fieldnames(mpctrl.daq);
end

if nargin > 0
    daqs    = GetDAQ(daqs);
    daqtype = daqs.Type;
    switch lower(type)
        case {'analoginput', 'analog input'}
            ind = strmatch('Analog Input',daqtype);
        case {'analogoutput', 'analog output'}
            ind = strmatch('Analog Output',daqtype);
        case {'digitalio', 'digital io'}
            ind = strmatch('Digital IO',daqtype);
        otherwise
            error('METAPHYS:noSuchDAQType',...
                'No such daq type %s', type)
    end
    daqs    = CellWrap(daqs(ind).Name);
end
            