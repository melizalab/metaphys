function r0 = Packet2R0(packet)
%
% PACKET2R0 Converts an array of packet structures into an array of r0
% structures.
%
% Packets are returned by DATAHANDLER as they are received from data
% acquisition hardware. R0 structures are organized by channel. This
% function remaps an array of packets into an array of r0 structures, one
% element for each channel in the data. Instrument information is ignored,
% so this needs to be sorted out ahead of time if it matters.
%
% See Also: PACKET_STRUCT, PACKET2R1, SPLITPACKET
%
% $Id: Packet2R0.m,v 1.2 2006/01/27 23:46:42 meliza Exp $

% the tricky thing here is that packets can have multiple channels. there
% can also be a lot of data, so looping through the packets is not a good
% idea without first figuring out how much space we need

% take multichannel packets and convert them to single channel ones
packet  = SplitPacket(packet);

channels    = {packet.channels};
uniq_chan   = unique(channels);
r0          = struct(size(uniq_chan,2));
for i = 1:size(uniq_chan,2)
    ind     = strmatch(uniq_chan{i}, channels, 'exact');
    data    = {packet(ind).data};
    datalen = cellfun('length',data);
    if length(unique(datalen)) > 1
        error('METAPHYS:packet2r0:unequalDataSize',...
            'Data arrays in packet were of unequal length. Try Packet2R1.')
    end
    data    = [data{:}];
    eptime  = [packet(ind).timestamp];
    % sort by eptime
    [eptime, sort_ind]  = sort(eptime);
    start_time  = eptime(1);
    eptime  = (eptime - start_time) .* 1440; % convert to minutes
    data    = data(:,sort_ind);
    r0(i)   = r0_struct(data, packet(ind(1)).time, eptime,...
        uniq_chan{i}, packet(ind(1)).units,...
        start_time);
end
