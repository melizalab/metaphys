function out = moviecontrol_default()
%
% MOVIECONTROL_DEFAULT Returns default values for the moviecontrol dialog
%
% See also: MOVIECONTROL, @F21CONTROL
%
% $Id: moviecontrol_default.m,v 1.3 2006/01/30 20:04:49 meliza Exp $

out = struct('remote_host', '',...
             'remote_port', 6543);