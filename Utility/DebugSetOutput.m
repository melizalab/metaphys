function [] = DebugSetOutput(debugmode, debugsink)
%
% DEBUGSETOUTPUT Sets the current debug mode.
%
% The debugmode determines what subsequent calls to DEBUGPRINT do.
%
% DEBUGSETOUTPUT('off') - Calls to DEBUGPRINT are ignored.
%
% DEBUGSETOUTPUT('console') - Calls to DEBUGPRINT are sent to the MATLAB
% console.
%
% DEBUGSETOUTPUT('file', filename) - Calls to DEBUGPRINT are output to the
% file referred to by <filename>. If the file exists, new entries are
% appended to it. NB: MATLAB allows multiple handles to be open to a file
% in append mode, so be sure to call DEBUGSETOUTPUT('off') to close the
% handle.
%
% Uses the MATLAB prefs METAPHYS/debugMode and METAPHYS/debugSink.
%
% See also: DEBUGPRINT
%
% $Id: DebugSetOutput.m,v 1.2 2006/01/30 20:04:55 meliza Exp $

%% Close existing debug file
closeDebugFile

%% Setup prefs for future debug message calls
switch lower(debugmode)
    case 'off'
        setpref('METAPHYS','debugMode',0)
    case 'console'
        setpref('METAPHYS','debugMode',1)
        setpref('METAPHYS','debugSink',1)   % STDOUT
    case 'file'
        fid     = openDebugFile(debugsink);
        setpref('METAPHYS', 'debugMode',1)
        setpref('METAPHYS', 'debugSink',fid)
    otherwise
end

function [fid] = openDebugFile(filename)
% Attempts to open a handle to the debug file
fid = fopen(filename, 'at');
if fid < 2
    error('METAPHYS:debug:invalidFilename',...
        'METAPHYS was unable to open a handle to the file %s',...
        filename)
end

function [] = closeDebugFile()
% If a debug file handle is specified in the prefs, close it
if ispref('METAPHYS', 'debugSink')
    fid     = getpref('METAPHYS', 'debugSink');
    % don't try to close stdout or stderr
    if fid > 2
        % don't try to close invalid files
        if ~isempty(fopen(fid))
            fclose(fid)
        end
    end
    setpref('METAPHYS', 'debugSink', -1)
end
