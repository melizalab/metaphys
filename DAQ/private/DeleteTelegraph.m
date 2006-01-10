function [] = DeleteTelegraph(instrument, telegraph)
%
% DELETETELEGRAPH Deletes a telegraph from an instrument, along with any
% associated objects or channels.
%
% $Id: DeleteTelegraph.m,v 1.2 2006/01/11 03:20:00 meliza Exp $
global mpctrl

%% Get telegraph structure
telestruct   = GetInstrumentTelegraph(instrument, telegraph);

%% Delete channel objects
obj = telestruct.object;
for i = 1:length(obj)
    if isa(obj(i), 'daqchild')
        delete(obj(i));
    end
end

%% Clear control field
fn  = 'mpctrl.instrument.(instrument).telegraph';
evs = sprintf('%s = rmfield(%s, %s)', fn, fn, telegraph);
eval(evs);