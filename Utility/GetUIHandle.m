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
%   Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

%% Find out if the module exists
module  = lower(module);

if ~isfield(mpctrl,module)
    error('METAPHYS:moduleNotFound', 'No such module %s.', module);
end

%% Retrieve the handle(s)
if nargin < 2
    tag     = fieldnames(mpctrl.(module).handles);
else
    tag     = lower(tag);
end

str     = GetFields(mpctrl.(module).handles, tag);
handle  = StructFlatten(str);
