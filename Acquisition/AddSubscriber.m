function []= AddSubscriber(name, instrument, fhandle, varargin)
%
% ADDSUBSCRIBER Adds a subscriber to the acquisition system.
%
% ADDSUBSCRIBER(name, instrument, fhandle, [fargs]) - subscribes
% <instrument> to the acquisition system. When data is returned by the DAQ,
% fhandle will be called (with arguments <fargs>, if supplied)
%
% ADDSUBSCRIBER(subscriber) - adds the subscriber structure defined by
% <subscriber> to control.
%
% If a previous subscription exists with the same name it will be
% overwritten.
%
% See also: SUBSCRIBER_STRUCT
%
% $Id: AddSubscriber.m,v 1.4 2006/01/30 20:04:33 meliza Exp $

global mpctrl

if ischar(name)
    S  = subscriber_struct(name, instrument, fhandle, varargin);
else
    S  = name;
end
S.name  = lower(S.name);

%% Check the arguments
if ~isnan(str2double(S.name(1)))
    error('METAPHYS:invalidArgument',...
        'Subscriber names must begin with a letter.')
end
% instrument can be empty
if isempty(S.instrument)
    S.instrument  = [];
elseif ~isnan(str2double(S.instrument(1)))
    error('METAPHYS:invalidArgument',...
        'The instrument name %s is invalid.', S.instrument)
end
if ~isa(S.fhandle, 'function_handle')
    error('METAPHYS:invalidArgument',...
        'Invalid function handle.')
end
                 
mpctrl.subscriber.(S.name)    = S;
DebugPrint('Added subscriber %s.', S.name);