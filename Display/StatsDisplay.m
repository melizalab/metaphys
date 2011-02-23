function [] = StatsDisplay(action, varargin)
%
% STATSDISPLAY Display module for plotting statistics
%
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

switch lower(action)
    case 'init'
    case 'clear'
    case 'destroy'
    otherwise
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end