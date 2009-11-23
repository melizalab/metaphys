function [sequence] = preparetuning(obj)
%
% PREPARETUNING Prepares the remote f21 for a tuning test. Returns the
% random sequence used.
%
% sequence = PREPARETUNING(f21ctrl)
%
% $Id: preparetuning.m,v 1.1 2006/01/24 03:26:08 meliza Exp $

out = sendrequest(obj, 'prepare');
tok = StrTokenize(out);
if length(tok) > 1 && strcmpi(tok{2},'finished')
    sequence  = Cell2Num(tok{3:end});
else
    error('METAPHYS:f21control:loadMovieFailed',...
        'Prepare movie failed: %s', out)
end