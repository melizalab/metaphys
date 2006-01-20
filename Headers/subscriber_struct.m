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
%  See Also: PACKET_STRUCT
%
% $Id: subscriber_struct.m,v 1.3 2006/01/20 22:02:34 meliza Exp $

fields  = {'name', 'instrument', 'fhandle', 'fargs'};
C       = {'', {}, [], {}};
req     = 3;

out     = StructConstruct(fields, C, req, varargin);
