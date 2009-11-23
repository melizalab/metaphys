function out    = isempty(obj)
%
% ISEMPTY Returns true if the waveform has no channels defined
%
% $Id: isempty.m,v 1.1 2006/01/26 23:37:33 meliza Exp $

out = isempty(obj.channel_names);