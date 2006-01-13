function S = GetFields(S, fieldnames)
%
% GETFIELDS Returns one or more fields from a structure in a new structure
%
% This function works like GETFIELD, but can accept multiple fieldnames,
% and instead of returning the contents of the field(s), returns a
% structure. Thus, GETFIELDS returns the subset of the structure determined
% by the fieldnames. If any of the fieldnames is invalid, an error is
% thrown.  The input structure must be 1x1
%
% S = GETFIELDS(S, fieldnames) - <fieldnames> can be a string or cell array
%                                of strings.
%
% $Id: GetFields.m,v 1.1 2006/01/14 00:48:15 meliza Exp $

fieldnames  = CellWrap(fieldnames);

assgn   = cell(2,length(fieldnames));
for i = 1:length(fieldnames)
    assgn{1,i}  = fieldnames{i};
    assgn{2,i}  = S.(fieldnames{i});
end

S   = struct(assgn{:});
    