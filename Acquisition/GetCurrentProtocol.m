function protocol   = GetCurrentProtocol()
%
% GETCURRENTPROTOCOL    Returns the current protocol
%
% GETCURRENTPROTOCOL  returns the handle of the current protocol, or if
% none is loaded, an empty array.
%
% See also: SETCURRENTPROTOCOL
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

protocol    = GetGlobal('current_protocol');