function c  = CellWrap(varargin)
%
% CELLWRAP Ensures that a variable is either a cell array or is wrapped in
% one.
%
% CELLWRAP(cell) returns the cell array without modifying it
% CELLWRAP(noncell) returns <noncell> as a single element in a cell array.
%                   The exception is if <noncell> is equal to [], in which
%                   case it is returned as is.
% CELLWRAP(noncell1,noncell2,...) returns the arguments in a cell array
%
%
% $Id: CellWrap.m,v 1.1 2006/01/11 03:20:02 meliza Exp $

if nargin == 1
    if iscell(varargin{1})
        c   = varargin{1};
    else
        if ~isempty(varargin{1})
            c   = {varargin{1}};
        else
            c   = [];
        end
    end
else
    c   = varargin;
end