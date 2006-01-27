function protocol   = GetCurrentProtocol()
%
% GETCURRENTPROTOCOL    Returns the current protocol
%
% GETCURRENTPROTOCOL  returns the handle of the current protocol, or if
% none is loaded, an empty array.
%
% $Id: GetCurrentProtocol.m,v 1.1 2006/01/28 00:46:07 meliza Exp $

protocol    = GetGlobal('current_protocol');