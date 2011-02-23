function [] = InitModule(module, figure)
%
% INITMODULE Initializes a module in the control structure. 
%
% Modules are accessed through a field that has the same name as the
% module, under which are three fields, fig, handles, and params. If a
% figure handle is supplied, INITMODULE will also ensure that it has the
% same name and tag as the module name.
%
% [] = INITMODULE(module, [figure])
%
% module (String) - module name
% figure (struct) - module figure handle. If not supplied, .fig and
%                   .handles will be empty
%
% See also: GETMODULE, INITCONTROL
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

module  = lower(module);

if nargin > 1
    set(figure, 'name', module, 'tag', module);
    z   = struct('fig', figure,...
                 'handles', guihandles(figure),...
                 'params', []);
else
    z   = struct('fig', [],...
                 'handles', [],...
                 'params', []);
end    
    
mpctrl.(module) = z;
