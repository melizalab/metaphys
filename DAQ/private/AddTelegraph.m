function [] = AddTelegraph(instrument, telegraph, type, object, checkfn, updfn, output)
%
% ADDTELEGRAPH Adds a telegraph to an instrument.
%
% $Id: AddTelegraph.m,v 1.4 2006/01/17 18:07:58 meliza Exp $
global mpctrl

instr   = GetInstrument(instrument);

% Check for existing telegraph of the same name and delete it
if isfield(instr.telegraph, telegraph)
    DeleteTelegraph(instrument, telegraph)
end

mystruct    = struct('name',telegraph,...
                     'type',type,...
                     'obj', object,...
                     'checkfn', checkfn,...
                     'updfn', updfn,...
                     'output', output);
                 
mpctrl.instrument.(instrument).telegraph.(telegraph)    = mystruct;
DebugPrint('Added telegraph %s/%s.', instrument, telegraph)