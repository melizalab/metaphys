function [] = SetCurrentProtocol(fhandle)
%
% SETCURRENTPROTOCOL    Sets the current protocol parameter
%
% SETCURRENTPROTOCOL(fhandle) should be called when a module has
% successfully initialized. It makes the protocol control buttons enabled
% in the main window, updates the status message, and give the main window
% a function handle to delete when loading a new protocol.
%
% SETCURRENTPROTOCOL([]) sets the current protocol as none - disabling the
% protocol control buttons, updating the status message, etc.
% 
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

MAIN_WINDOW = 'metaphys';
PROTOCOL_BUTTONS = {'protocol_start', 'protocol_record'};

if ~isempty(fhandle) && ishandle(fhandle)
    SetGlobal('current_protocol', fhandle);
    SetStatus('protocol initialized')
    h   = GetUIHandle(MAIN_WINDOW, PROTOCOL_BUTTONS);
    set(h,'enable','on')
else
    SetGlobal('current_protocol', []);
    SetStatus('protocol closed')
    h   = GetUIHandle(MAIN_WINDOW, PROTOCOL_BUTTONS);
    set(h,'enable','off')
end
    
    