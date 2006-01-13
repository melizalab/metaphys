function telestruct = telegraph_struct()
%
% TELEGRAPH_STRUCT Header for the telegraph structure
%
% Fields:
%
%           .name       - the name of the telegraph
%           .type       - the type of the telegraph
%           .obj        - the input object (channel or matlab object)
%           .checkfn    - function handle that checks the telegraph values
%           .updfn      - function handle that updates the instrument
%           .output     - arguments that define the output of the telegraph
%
% $Id: telegraph_struct.m,v 1.2 2006/01/14 00:48:14 meliza Exp $

telestruct  = struct('name','',...
                     'type','',...
                     'obj', [],...
                     'checkfn', [],...
                     'updfn', [],...
                     'output', []);