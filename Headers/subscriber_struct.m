function out = subscriber_struct(varargin)
%
% SUBSCRIBER_STRUCT Returns the header for the subscriber structure
%
% Fields:
%
%   .name           - the name of the subscription
%   .instrument     - cell array containing the names of the subscribed
%                     instruments
%   .fhandle        - the function handle that will be called when new data
%                     arrives
%   .fargs          - any additional arguments to pass to fhandle
%
%  The function referred to by <fhandle> must accept a single argument,
%  which consists of a structure as described by PACKET_STRUCT
%
%  See also: PACKET_STRUCT
%
% $Id: subscriber_struct.m,v 1.4 2006/01/30 20:04:51 meliza Exp $

fields  = {'name', 'instrument', 'fhandle', 'fargs'};
C       = {'', {}, [], {}};
req     = 3;

out     = StructConstruct(fields, C, req, varargin);
