function time   = getmovietime(obj, display_obj)
%
% GETMOVIETIME Returns the amount of time (in ms) it will take to play the
% movie, including trigger delay
%
% [time] = GETMOVIETIME(obj, display_obj) - for f21mvx, returns the amount
% of time it will take to play the movie in object <display_obj>
%
% [time] = GETMOVIETIME(obj) - for f21mv, returns the amount of time it
% will take to play the movie
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin > 1
    [mov frms] = getmovielist(obj, display_obj);
else
    [mov frms] = getmovielist(obj);
end

props   = get(obj);

frames  = sum(frms,1);
time    = frames ./ props.refresh_rate .* props.frame_rate_factor .*...
            1000 + props.time_before_trigger;