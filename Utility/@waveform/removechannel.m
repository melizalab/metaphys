function obj    = removechannel(obj, channel)
%
% REMOVECHANNEL Returns a modified waveform object after deleting a channel
%
% REMOVECHANNEL(waveform, C) Removes the channel C from WAVEFORM. C can be
% numeric or a character array.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

ind                 = getchanindex(obj, channel);
newind              = setdiff(1:length(obj.channel_names), ind);
obj.channel_names   = obj.channel_names(newind);
obj.channel_events  = obj.channel_events(newind);
