function [] = DeleteInstrument(name)
%
% DELETEINSTRUMENT Deletes an instrument from the control structure, and
% all of the associated inputs and outputs. 
%
% Note that attempting to delete channels that are currently involved in
% data acquisition will result in an error.
%
% DELETEINSTRUMENT(name)
%
% name           - the name of the instrument to be deleted. If this does
%                  not exist a warning is issued and no action is taken.
%
% See Also: DELETEINSTRUMENTCHANNEL
%
% $Id: DeleteInstrument.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

global mpctrl

name = lower(name);

if isfield(mpctrl.instrument, name)
    DeleteInstrumentChannel(name, 'all')
    mpctrl.instrument   = rmfield(mpctrl.instrument, name);
else
    warning('METAPHYS:daq:noSuchInstrument',...
        'No such instrument %s has been defined.', name)
end