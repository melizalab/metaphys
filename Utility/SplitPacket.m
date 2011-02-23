function S  = SplitPacket(P)
%
% SPLITPACKET Converts multichannel packet(s) into multiple single-channel
% packets.
%
% S = SPLITPACKET(packet) - packet can be a single packet or an array
%
% The packets returned are slightly broken with regard to the spec since
% the channel and unit names are character rather than cell arrays. This,
% however, is necessary for some functions that use this function.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

chancounts  = cellfun('length',{P.channels});

% pre-allocate
S   = repmat(packet_struct, sum(chancounts), 1);
ind = 1;

for i = 1:length(P)
    for j = 1:length(P(i).channels)
        S(ind)  = packet_struct(P(i).name, P(i).instrument, P(i).channels{j},...
            P(i).units{j},...
            P(i).data(:,j), P(i).time, P(i).timestamp, P(i).message);
        ind     = ind+1;
    end
end