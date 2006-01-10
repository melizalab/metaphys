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
% $Id: SetUIParam.m,v 1.1 2006/01/10 20:59:53 meliza Exp $

% retrieve the object handle
handle  = GetUIHandle(module, tag);

% attempt to set the property/ies
if nargin < 4
    value   = varargin{1};
    if isnumeric(value)
        value   = num2str(value);
    end
    set(handle, 'String', value);
else
    set(handle, varargin{:});
end
    