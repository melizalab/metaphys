function out = packet_struct(varargin)
%
% PACKET_STRUCT Returns the header for the data packet structure.
%
% Fields:
%
%   .name       - the name of the subscription returning this data
%   .instrument - the name of the instrument returning the data
%   .channels   - the names of the channels returned in this packet
%   .units      - the units of the data in each channel
%   .data       - an NxM array, with each channel's data in a column
%   .time       - a 1xM array with the offset time of each sample
%   .timestamp  - the absolute start time of the data, as a serial date #
%   .message    - diagnostic information. generally empty if the packet was
%                 returned under normal conditions
%
% $Id: packet_struct.m,v 1.3 2006/01/20 02:03:13 meliza Exp $

fields  = {'name', 'instrument', 'channels', 'units', 'data', 'time',...
           'timestamp', 'message'};
C       = {'', '', {}, {}, [], [], [], ''};
req     = size(fields,2);

out     = StructConstruct(fields, C, req, varargin);
