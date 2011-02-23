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
% See also DELETEINSTRUMENTCHANNEL
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

name = lower(name);

if isfield(mpctrl.instrument, name)
    DeleteInstrumentChannel(name, 'all')
    DeleteInstrumentTelegraph(name, 'all')
    mpctrl.instrument   = rmfield(mpctrl.instrument, name);
else
    warning('METAPHYS:daq:noSuchInstrument',...
        'No such instrument %s has been defined.', name)
end


DebugPrint('Deleted instrument %s.', name);