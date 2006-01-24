function out = moviecontrol_default()
%
% MOVIECONROL_DEFAULT: Returns default values for the moviecontrol dialog
%
% $Id: moviecontrol_default.m,v 1.1 2006/01/25 01:31:39 meliza Exp $

out = struct('remote_host', '',...
             'remote_port', 6543);