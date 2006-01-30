function out = moviecontrol_default()
%
% MOVIECONTROL_DEFAULT Returns default values for the moviecontrol dialog
%
% $Id: moviecontrol_default.m,v 1.2 2006/01/30 19:23:12 meliza Exp $

out = struct('remote_host', '',...
             'remote_port', 6543);