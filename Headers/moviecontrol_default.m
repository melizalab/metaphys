function out = moviecontrol_default()
%
% MOVIECONTROL_DEFAULT Returns default values for the moviecontrol dialog
%
% See also: MOVIECONTROL, @F21CONTROL
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out = struct('remote_host', '',...
             'remote_port', 6543);