function out  = step_function(T, X, onset, ampl, dur, varargin)
%
% STEP_FUNCTION The default function used to apply onset, amplitude, and
% duration values to a waveform.
%
% STEP_FUNCTION is a step function. Very basic. Might have trouble with
% enormous arrays.
%
% $Id: step_function.m,v 1.1 2006/01/26 01:21:36 meliza Exp $

% figure out the output size; parameters are the same length
M       = size(X,2);
Q       = size(onset,1);
N       = size(T,1);

T       = repmat(T,1,Q*M);
X       = repmat(X,1,Q);

% only use the first column
offset  = onset + dur;
onset   = repmat(onset(:,1)',N,M);
offset  = repmat(offset(:,1)',N,M);
ampl    = repmat(ampl(:,1)',N,M);

out     = X + ((T >= onset) & (T < offset)) .* ampl;
