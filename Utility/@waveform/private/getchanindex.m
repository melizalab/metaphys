function chanindex  = getchanindex(obj, channame)
%
% GETCHANINDEX converts character references to channels to numeric indices
%
% $Id: getchanindex.m,v 1.1 2006/01/26 23:37:34 meliza Exp $

if any(size(obj) > 1)
    error('METAPHYS:waveform:invalidArgument',...
        'This method only operates on single objects.');
end

if ischar(channame)
    chanindex = strmatch(channame, obj.channel_names);
elseif channame > getchannelcount(obj)
    chanindex = [];
else
    chanindex = channame;
end
