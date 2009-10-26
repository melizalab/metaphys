function daq = GetDAQStruct(daqnames)
%
% GETDAQSTRUCT Returns the DAQ structs referred to by their tags. 
%
% If multiple tags are supplied then an array of daq structs is returned.
% Checks for validity.
%
% daq = GETDAQSTRUCT(daqnames)
%
% $Id: GetDAQStruct.m,v 1.1.1.1 2006/01/10 20:59:51 meliza Exp $

if iscell(daqnames)
    for i = 1:length(daqnames)
        daq(i)  = getdaqstr(daqnames{i});
    end
else
    daq     = getdaqstr(daqnames);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function daq  = getdaqstr(daqname)
global mpctrl
%daqname = lower(daqname);

if isfield(mpctrl.daq, daqname)==0
    error('METAPHYS:daq:deviceNotFound','No daq device %s exists.',daqname)
end

daq = mpctrl.daq.(daqname);
if isvalid(daq.obj)==0
    warning('METAPHYS:daq:invalidDevice',...
        'The DAQ object %s no longer exists.', daqname);
end