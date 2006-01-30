function [s] = r0_struct(varargin)
%
% R0_STRUCT     Constructor for the r0 data structure
%
% r0 structures are used to describe episodic responses to periodic
% stimulation. For each channel, episodes are required to be the same
% length. Multiple channels of data can be stored as an array of r0
% structures.
%
% Required fields:
%
% .data       - the response, which is an NxM array of M episodes of N
%               samples
% .time       - an Nx1 vector describing the time offset of each 
%               sample (in milliseconds)
% .eptime     - an Mx1 vector describing the time offset of each 
%               episode (in minutes)
% .channel    - the channel name (string)
% .units      - the units of the channel (string)
% .start_time - a serial date number defining the start time of the data
%
% Optional fields:
%
% .instrument - the instrument this data came from
%
% See also: R1_STRUCT
%
% $Id: r0_struct.m,v 1.3 2006/01/30 20:04:50 meliza Exp $

fields  = {'data','time','eptime','channel','units','start_time','instrument'};
C       = {[],[],[],'','',[],''};
req     = 6;

s       = StructConstruct(fields, C, req, varargin);
