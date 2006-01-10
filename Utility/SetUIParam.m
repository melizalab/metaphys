function [] = SetUIParam(module, tag, varargin)
% SETUIPARAM Sets a parameter of an object stored in the control
% structure.
% 
% []  = SETUIPARAM(module, tag, field, value)
% 		Sets the field 'value' to VALUE
%       field and value can be cell arrays or a comma-delimited list (see
%       SET)
% 	
% For example, to set the value displayed in an edit uicontrol, call
% SETUIPARAM('mymodule', 'editcontroltag', 'String', '1234')
%
% []  = SETUIPARAM(module, tag, value)
%
% Since the 'String' property is so commonly used, this shorter form will
% set the 'String' property. This form will also attempt to cast numeric
% values to strings.
%
% $Id: SetUIParam.m,v 1.2 2006/01/11 03:20:04 meliza Exp $

% retrieve the object handle
handle  = GetUIHandle(module, tag);

% attempt to set the property/ies
if nargin < 4
    value   = varargin{1};
    if isnumeric(value)
        value   = num2str(value);
    end
    arguments   = {'String', value};
else 
    arguments   = varargin;
end

set(handle, arguments{:});

% There are serious issues with setting the 'String' or 'Value' properties
% on list and popupmenu objects, because if the Value is out of range of
% the string options, the list will refuse to display. So this is some
% error handling that will save on a lot of code elsewhere.
if isprop(handle, 'style')
    style   = get(handle,'style');
    switch style
        case {'listbox','popupmenu'}
            v   = get(handle,'Value');
            s   = get(handle,'String');
            if iscell(s)
                if v > length(s)
                    v = length(s);
                elseif v < 1
                    v = 1;
                end
            elseif strcmpi(s,' ')
                v   = 1;
            elseif isempty(s)
                v   = 1;
                set(handle,'String', ' ')
            end

            set(handle, 'Value', v)
    end
end

                    
                        
    