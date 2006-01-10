function out = GetUIParam(module, tag, field)
% GETUIPARAM Retrieve the value of a parameter stored in a MATLAB GUI
% object. 
%
% In order to be accessible, the object must be created in the control
% structure (created using INITUIOBJECT or INITUICONTROL).
%
% out = GETUIPARAM(module, [tag, [field]])
%
%   MODULE  - the module in wc
%   TAG     - the tag for the GUI object. If tag is not supplied, a cell
%             array containing all the uiparams names for the module is
%             returned
%   FIELD   - The property to be retrieved. In addition to the existing
%   properties of the object, the following virtual properties can be
%   accessed:
%
%   'StringVal' - if the object has a 'String' property, casts it to a
%                 number.
%   'Selected'  - if the object has 'String' and 'Value' properties,
%                 returns the currently selected string.  Or, if the 
%                 object is a uibuttongroup, returns the tag of the
%                 currently selected item (or '' if none is selected)
%
%   For example, to get the value entered into an edit ui control, call
%   GETUIPARAM('mymodule','editcontroltag','StringVal')
%
%   If FIELD is not supplied, the default is 'String'
%
%   See Also: GETSELECTED
%
%   $Id: GetUIParam.m,v 1.1 2006/01/10 20:59:52 meliza Exp $

if nargin == 1
    handles = GetUIHandle(module);
    out     = get(handles,'tag');
else
    handle  = GetUIHandle(module, tag);

    if nargin < 3
        field   = 'String';
    end

    % Retrieve/parse the property
    switch lower(field)
        case 'stringval'
            out = str2num(get(handle,'String'));
        case 'selected'
            out = GetSelected(handle);
        otherwise
            out = get(handle, field);
    end
end
    