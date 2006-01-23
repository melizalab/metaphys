function C  = Cell2Num(C)
%
% CELL2NUM Casts as many elements to numbers in a cell array as possible.
% The cell array must contain only character arrays.
%
% C = CELL2NUM(C)
%
% $Id: Cell2Num.m,v 1.1 2006/01/24 03:26:11 meliza Exp $

try
    NC  = cellfun(@str2num, C, 'uniformoutput', false);
    EC  = ~cellfun('isempty', NC);
    C(EC)   = NC(EC);
catch
    error('METAPHYS:cell2num:invalidArgument',...
        'Input cell array must contain only character arrays')
end
