function count  = getchannelcount(obj)
%
% GETCHANNELCOUNT Returns the number of channels defined on the waveform
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

count   = length(obj.channel_names);
