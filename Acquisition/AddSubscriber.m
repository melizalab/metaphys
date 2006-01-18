function []= AddSubscriber(name, instrument, fhandle, varargin)
%
% ADDSUBSCRIBER Adds a subscriber to the acquisition system.
%
% ADDSUBSCRIBER(name, instrument, fhandle, [fargs]) - subscribes
% <instrument> to the acquisition system. When data is returned by the DAQ,
% fhandle will be called (with arguments <fargs>, if supplied)
%
% See Also: SUBSCRIBER_STRUCT
%
% $Id: AddSubscriber.m,v 1.1 2006/01/18 19:01:02 meliza Exp $

global mpctrl

%% Check the arguments
if ~isnan(str2double(name(1)))
    error('METAPHYS:invalidArgument',...
        'Subscriber names must begin with a letter.')
end
if ~isnan(str2double(instrument(1)))
    error('METAPHYS:invalidArgument',...
        'The instrument name %s is invalid.', instrument)
end
% instruments are checked at runtime
if ~isa(fhandle, 'function_handle')
    error('METAPHYS:invalidArgument',...
        'Invalid function handle.')
end

subscriber  = struct('name', name,...
                     'instrument',instrument,...
                     'fhandle', fhandle,...
                     'fargs',{varargin});
                 
mpctrl.subscriber.(name)    = subscriber;
DebugPrint('Added subscriber %s.', name);