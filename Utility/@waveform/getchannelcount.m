function count  = getchannelcount(obj)
%
% GETCHANNELCOUNT Returns the number of channels defined on the waveform
%
% $Id: getchannelcount.m,v 1.1 2006/01/26 23:37:32 meliza Exp $

count   = length(obj.channel_names);
