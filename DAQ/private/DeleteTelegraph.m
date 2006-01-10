function [] = DeleteTelegraph(instrument, telegraph)
%
% DELETETELEGRAPH Deletes a telegraph from an instrument, along with any
% associated objects or channels.
%
% $Id: DeleteTelegraph.m,v 1.1 2006/01/10 20:59:51 meliza Exp $
global mpctrl

%% Check validity of arguments
if ~isfield(mpctrl.instrument, instrument)
    error('METAPHYS:daq:noSuchInstrument',...
        'No such instrument %s has been defined.', instrument)
end

if ~isfield(mpctrl.instrument.(instrument).telegraph, telegraph)
    error('METAPHYS:daq:noSuchTelegraph',...
        'No such telegraph %s defined for instrument %s.',...
        telegraph, instrument)
end

%% Delete channel objects
obj = mpctrl.instrument.(instrument).telegraph.(telegraph).object;
for i = 1:length(obj)
    if isa(obj(i), 'daqchild')
        delete(obj(i));
    end
end

%% Clear control field
fn  = 'mpctrl.instrument.(instrument).telegraph';
evs = sprintf('%s = rmfield(%s, %s)', fn, fn, telegraph);
eval(evs);