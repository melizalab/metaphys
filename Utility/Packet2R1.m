function r1 = Packet2R1(packet)
%
% PACKET2R1 Converts an array of packet structures into an array of r1
% structures.
%
% Packets are returned by DATAHANDLER as they are received from data
% acquisition hardware. R1 structures are organized by channel and sweep. 
% Each channel of each sweep has its own structure in the R1 array. This
% function remaps an array of packets into an array of r1 structures.
%
% See also: R1_STRUCT, PACKET2R0, SPLITPACKET
% 
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% The R1 structure is very similar to the packet structure, except only one
% data channel is allowed. Also, it's nice to sort the packets.

% take multichannel packets and convert them to single channel ones
packet  = SplitPacket(packet);
eptime  = cat(1,packet.timestamp);
[eptime sort_ind]   = sort(eptime);

% it's a royal pain to rename fields, but better than looping
eptime  = mat2cell(eptime, ones(size(eptime)));
chan    = {packet.channels};

r1      = rmfield(packet(sort_ind), {'name', 'message', 'timestamp','channels'});
[r1.start_time] = deal(eptime{:});
[r1.channel]    = deal(chan{:});
