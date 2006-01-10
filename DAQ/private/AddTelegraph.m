function [] = AddTelegraph(instrument, telegraph, object, checkfn, updfn, output)
%
% ADDTELEGRAPH Adds a telegraph to an instrument.
%
% $Id: AddTelegraph.m,v 1.1 2006/01/10 20:59:51 meliza Exp $
global mpctrl

if ~isfield(mpctrl.instrument, instrument)
    error('METAPHYS:daq:noSuchInstrument',...
        'No such instrument %s has been defined.', instrument)
end

% Check for existing telegraph of the same name and delete it
if isfield(mpctrl.instrument.(instrument).telegraph, telegraph)
    DeleteTelegraph(instrument, telegraph)
end

mystruct    = struct('object', object,...
                     'checkfn', checkfn,...
                     'updfn', updfn,...
                     'output', output);
                 
mpctrl.instrument.(instrument).telegraph.(telegraph)    = mystruct;                 