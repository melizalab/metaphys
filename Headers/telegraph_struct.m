function telestruct = telegraph_struct()
%
% TELEGRAPH_STRUCT Header for the telegraph structure
%
% Fields:
%
%           .obj        - the input object (channel or matlab object)
%           .checkfn    - function handle that checks the telegraph values
%           .updfn      - function handle that updates the instrument
%           .output     - arguments that define the output of the telegraph
%
% $Id: telegraph_struct.m,v 1.1 2006/01/11 23:04:02 meliza Exp $

telestruct  = struct('obj', [],...
                     'checkfn', [],...
                     'updfn', [],...
                     'output', []);