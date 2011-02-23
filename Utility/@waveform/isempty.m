function out    = isempty(obj)
%
% ISEMPTY Returns true if the waveform has no channels defined
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out = isempty(obj.channel_names);