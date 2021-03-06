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
% SETUIPARAM('mymodule', 'editcontroltag', 'String', '1234'). A special
% property 'Selected' is provided, which attempts to find the index of the
% value in the 'String' property, and sets the 'Value' property to that
% index. If the string cannot be found, nothing is done. If this argument
% is used, it must be the only property set.
%
% []  = SETUIPARAM(module, tag, value)
%
% Since the 'String' property is so commonly used, this shorter form will
% set the 'String' property. This form will also attempt to cast numeric
% values to strings.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% retrieve the object handle
handle  = GetUIHandle(module, tag);

% attempt to set the property/ies
if strcmpi(varargin{1},'selected')
    setselected(handle, varargin{2});
else
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
end

% There are serious issues with setting the 'String' or 'Value' properties
% on list and popupmenu objects, because if the Value is out of range of
% the string options, the list will refuse to display. So this is some
% error handling that will save on a lot of code elsewhere.
if isprop(handle, 'style')
    style   = get(handle,'style');
    switch style
        case 'listbox'
            v   = get(handle,'Value');
            s   = get(handle,'String');
            if isempty(s)
                % if string = {}, the value doesn't matter
                s   = {};
            elseif strcmpi(s,' ')
                s   = {};
            else
                % character arrays are too much trouble
                if ischar(s)
                    s  = cellstr(s);
                end
                % check for valid selections
                if isempty(v)
                    v   = 1;
                end
                v(v > length(s))    = length(s);
                v(v < 1)            = 1;
                
            end
            set(handle,'String', s, 'Value', v)
        case 'popupmenu'
            % unlike listboxes, popupmenus can only have one item selected,
            % and the string property can't be empty
            v   = get(handle,'Value');
            s   = get(handle,'String');
            if isempty(s)
                s   = ' ';
            end
            if ischar(s)
                s   = cellstr(s);
            end
            if isempty(v)
                v   = 1;
            end
            v(v > length(s))    = length(s);
            v(v < 1)            = 1;
            v                   = v(1);
            set(handle,'String', s)
            set(handle, 'Value', v)
    end
end
    