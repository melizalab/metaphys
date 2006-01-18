function out = packet_struct()
%
% PACKET_STRUCT Returns the header for the data packet structure.
%
% Fields:
%
%   .name       - the name of the subscription returning this data
%   .instrument - the name of the instrument returning the data
%   .channels   - the names of the channels returned in this packet
%   .data       - an NxM array, with each channel's data in a column
%   .time       - a 1xM array with the offset time of each sample
%   .timestamp  - the absolute start time of the data, as a serial date #
%   .message    - diagnostic information. generally empty if the packet was
%                 returned under normal conditions
%
% $Id: packet_struct.m,v 1.1 2006/01/18 19:01:09 meliza Exp $

out = struct('name','',...
             'instrument','',...
             'channels',{{}},...
             'data',[],...
             'time',[],...
             'timestamp',[],...
             'message','');