function [] = StatsDisplay(action, varargin)
%
% STATSDISPLAY Display module for plotting statistics
%
%
% $Id: StatsDisplay.m,v 1.1 2006/01/27 23:46:31 meliza Exp $

switch lower(action)
    case 'init'
    case 'clear'
    case 'destroy'
    otherwise
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end