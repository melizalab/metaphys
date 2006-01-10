function [] = AddTelegraph(instrument, telegraph, object, checkfn, updfn, output)
%
% ADDTELEGRAPH Adds a telegraph to an instrument.
%
% $Id: AddTelegraph.m,v 1.2 2006/01/11 03:20:00 meliza Exp $
global mpctrl

instr   = GetInstrument(instrument);

% Check for existing telegraph of the same name and delete it
if isfield(instr.telegraph, telegraph)
    DeleteTelegraph(instrument, telegraph)
end

mystruct    = struct('object', object,...
                     'checkfn', checkfn,...
                     'updfn', updfn,...
                     'output', output);
                 
mpctrl.instrument.(instrument).telegraph.(telegraph)    = mystruct;