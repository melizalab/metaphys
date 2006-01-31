function [out] = DAQ2R1(files, varargin)
%
% DAQ2R1 Reads in a list of daq files and generates an r1 structure
%
% Usage: r1 = DAQ2R1(files, [channels], [instrumenttype, scaledchannels])
%
% files         - cell array of file names to be read in
% channels      - indices of the channels to keep
% instrumenttype- the type of the instrument (needed for telegraph parsing)
% scaledchannels- indices of the channels to scale using telegraph info
%
% r1           - output structure
%
% Like DAQ2R0, DAQ2R1 reads in a collection of .daq files and converts them
% to a more readily accessed data structure. It will only include the
% specified channels in the final structure. If the daqfile contains
% telegraph data (identified by the names of the channels) and if the user
% specifies channels to be scaled, the function will attempt to set the
% units and scaling of those channels.
%
% See also:     R1_STRUCT, DAQ2R0, DAQ2PACKET
%
% $Id: DAQ2R1.m,v 1.1 2006/01/31 23:06:12 meliza Exp $

out = r1_struct;
if isa(files,'char')
    files = {files};
end

for i = 1:length(files);
    packet(i)    = DAQ2Packet(files{i}, varargin{:});
end
out  = Packet2R1(packet);