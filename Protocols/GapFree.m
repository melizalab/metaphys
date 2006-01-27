function varargout = GapFree(action)
%
% GAPFREE Protocol for continuous display of data.
%
% GAPFREE displays data from one or more channels during continuous
% acquisition; it retrieves the data at fixed intervals and plots it using
% SCOPEDISPLAY
%
% $Id: GapFree.m,v 1.3 2006/01/27 23:46:35 meliza Exp $

% Parse action
switch lower(action)
    case 'init'
        % Load default parameters for this protocol
        p = GetDefaults(me);
        p.instrument.callback   = @selectInstrument;
        % Open the parameter window
        movegui(ParamFigure(me, p, @destroyModule),'east')
        instr   = GetParam(me, 'instrument');
        % Open the display scope
        ScopeDisplay('init', instr)
        setStatus('protocol initialized');
    
    case 'start'
        % Clear displays
        ScopeDisplay('clear')
        StopDAQ
        % Setup data handling
        SetDataStorage('memory')
        % Call the sweep control function
        sweepControl
    
    case 'record'
        % Clear displays
        ScopeDisplay('clear')
        StopDAQ
        % Setup data handling
        SetDataStorage('daqfile')
        % Call the sweep control function
        sweepControl
    
    case 'stop'
        StopDAQ
        setStatus('protocol stopped');
        
    case 'destroy'
        destroyModule;
    otherwise
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = me()
% This function is here merely for convenience so that
% the value 'me' refers to the name of this mfile (which
% is used in accessing parameter values)
out = mfilename;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = sweepControl()

% Start a sweep
updaterate  = GetParam(me, 'update_rate');
interval    = 1000/updaterate;
StartContinuous(interval)
setStatus('protocol running')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setStatus(output)
SetUIParam('metaphys','protocol_status',output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = selectInstrument(varargin)
% handles when the user chooses a new instrument
StopDAQ
instr   = GetParam(me, 'instrument');
setStatus('instrument changed: protocol stopped')
ScopeDisplay('init',instr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = destroyModule(varargin)
% call stop action
feval(me, 'stop');
% save current values to control structure
p   = GetParam(mfilename);
SetDefaults(mfilename,'control',p)
% delete display windows
DeleteModule('scopedisplay')
