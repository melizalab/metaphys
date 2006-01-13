function handle = GetUIHandle(module, tag)
% GETUIHANDLE Returns the handle(s) of UI objects stored in the control
% structure.
%
% handle = GETUIHANDLE(module, [tag])
%
%   module - the module name
%   tag    - the tag for the GUI object. If this is not supplied, all the
%            handles will be returned
%
%   $Id: GetUIHandle.m,v 1.2 2006/01/14 00:48:15 meliza Exp $

global mpctrl

%% Find out if the module exists
module  = lower(module);
tag     = lower(tag);

if ~isfield(mpctrl,module)
    error('METAPHYS:moduleNotFound', 'No such module %s.', module);
end

%% Retrieve the handle(s)
if nargin < 2
    tag     = fieldnames(mpctrl.(module).handles);
end

str     = GetFields(mpctrl.(module).handles, tag);
handle  = StructFlatten(str);

% if nargin < 2
%     handle  = struct2array(mpctrl.(module).handles);
% else
%     tag     = lower(tag);
%     if ~isfield(mpctrl.(module).handles, tag)
%         error('METAPHYS:tagNotFound', 'No such tag %s in module %s.',...
%             tag, module);
%     end
%     handle   = mpctrl.(module).handles.(tag);
% end