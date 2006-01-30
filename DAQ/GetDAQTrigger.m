function [triggertype dio dioline] = GetDAQTrigger(daq)
%
% GETDAQTRIGGER Returns information on how the daq is triggered
%
% [triggertype dio dioline] = GETDAQTRIGGER(daqname)
% [triggertype dio dioline] = GETDAQTRIGGER(daqobj)
%
% <triggertype> can be 'Immediate', 'Manual', 'Linked', 'Hardware',
% 'Digital' (see SETDAQTRIGGER), or 'none' (in the case of dio daqs)
%
% If <triggertype> is 'digital', then <dio> and <dioline> will be the name
% of the dio object and the dio lines used for digital triggering
%
% See also: SETDAQTRIGGER
%
% $Id: GetDAQTrigger.m,v 1.3 2006/01/30 20:04:39 meliza Exp $

if ischar(daq)
    daq     = GetDAQ(daq);
end

type    = daq.Type;
dio     = '';
dioline = [];
if strcmpi(type, 'digital io')
    triggertype = 'none';
else
    ttype   = daq.TriggerType;
    udata   = daq.UserData;
    switch lower(ttype)
        case 'immediate'
            triggertype = 'immediate';
        case 'manual'
            if strcmpi(type, 'analog input')
                if strcmpi(daq.ManualTriggerHwOn, 'trigger')
                    triggertype = 'linked';
                else
                    triggertype = 'manual';
                end
            else
                triggertype = 'manual';
            end
        case 'hwdigital'
            if isempty(udata)
                triggertype = 'hardware';
            else
                triggertype = 'digital';
                diolines    = udata;
                dio         = get(diolines(1).Parent,'Name');
                dioline     = diolines.HwLine;
                if iscell(dioline)
                    dioline = cell2mat(dioline);
                    dioline = dioline(:)';
                end
            end
        otherwise
            warning('METAPHYS:getdaqtrigger:unknownTriggerType',...
                'Unable to determine trigger type.');
            triggertype = lower(ttype);
    end
end