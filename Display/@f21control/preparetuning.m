function [sequence] = preparetuning(obj)
%
% PREPARETUNING Prepares the remote f21 for a tuning test. Returns the
% random sequence used.
%
% sequence = PREPARETUNING(f21ctrl)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out = sendrequest(obj, 'prepare');
tok = StrTokenize(out);
if length(tok) > 1 && strcmpi(tok{2},'finished')
    sequence  = Cell2Num(tok{3:end});
else
    error('METAPHYS:f21control:loadMovieFailed',...
        'Prepare movie failed: %s', out)
end