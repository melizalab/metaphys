function chanindex  = getchanindex(obj, channame)
%
% GETCHANINDEX converts character references to channels to numeric indices
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

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
