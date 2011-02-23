function [] = DebugPrint(varargin)
%
% DEBUGPRINT Outputs debugging messages. 
%
% The behavior of this function depends on previous calls to
% DEBUGSETOUTPUT.  If the debug mode is set to 'off', this function returns
% without doing anything; if it is set to 'console' or 'file', the debug
% message will be written to the console or debug file.
%
% DEBUGPRINT(message)
%
% DEBUGPRINT(formatmessage, A, B,...)
%
% DEBUGPRINT can be called with a simple string message, or with a
% formatted string and arguments (as with fprintf or sprintf). DEBUGPRINT
% may throw an error if DEBUGSETOUTPUT has not been called and the
% appropriate preferences not initialized.
%
% See also: DEBUGSETOUTPUT
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%

if(getpref('METAPHYS', 'debugMode'))
    fid     = getpref('METAPHYS', 'debugSink');
    % Add timestamp, caller, and \n
    stack       = dbstack;
    caller      = stack(2).file;
    varargin{1} = sprintf('[%s] %s: %s\n',...
        datestr(now), caller, varargin{1}); 
    fprintf(fid, varargin{:});
end
