function out = GetSelected(handle)
% GETSELECTED Returns the string selected in a list or popupmenu
% uicontrol. 
%
% If multiple items are selected, a character array is returned. If the
% handle refers to a uibuttongroup object, then the tag of the currently
% selected button is returned.
%
% Usage: selected = GETSELECTED(handle)
%
% handle - graphics object handle for the list or uicontrol
%
% $Id: GetSelected.m,v 1.1 2006/01/10 20:59:52 meliza Exp $

type    = get(handle,'type');
switch type
    case 'uicontrol'
        i = get(handle,'Value');
        s = get(handle,'String');
        if iscell(s)
            out = char({s{i}});
        elseif i <= length(s)
            out = s(i,:);
        else
            out = s;
        end
    case 'uipanel'
        % uibuttongroup is actually type 'uipanel', so we have to check if
        % the SelectedObject property exists
        if isprop(handle,'SelectedObject')
            selected    = get(handle, 'SelectedObject');
            if ishandle(selected)
                out     = get(selected, 'tag');
            else
                out     = [];
            end
        else
            error('METAPHYS:invalidObjectType',...
                'GETSELECTED can only be used with uicontrols and uibuttongroups');
        end
end
            