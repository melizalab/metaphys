function S = GetFields(S, fieldnames)
%
% GETFIELDS Returns one or more fields from a structure in a new structure
%
% This function works like GETFIELD, but can accept multiple fieldnames,
% and instead of returning the contents of the field(s), returns a
% structure. Thus, GETFIELDS returns the subset of the structure determined
% by the fieldnames. If any of the fieldnames is invalid, an error is
% thrown.  The input structure must be 1x1. If it is not a structure, []
% will be returned.
%
% S = GETFIELDS(S, fieldnames) - <fieldnames> can be a string or cell array
%                                of strings.
%
% $Id: GetFields.m,v 1.2 2006/01/19 03:15:04 meliza Exp $

if isstruct(S)
    fieldnames  = CellWrap(fieldnames);

    assgn   = cell(2,length(fieldnames));
    for i = 1:length(fieldnames)
        assgn{1,i}  = fieldnames{i};
        assgn{2,i}  = S.(fieldnames{i});
    end

    S   = struct(assgn{:});
else
    S   = [];
end
    