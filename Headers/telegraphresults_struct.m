function S = telegraphresults_struct(varargin)
%
% TELEGRAPHRESULTS_STRUCT Header for the structure containing telegraph
% results
%
% Telegraphresult structures are generally passed as arrays, one element
% for each channel to be modified, but can also be passed with a cell array
% of channel names.
%
% Fields:
%
%           .instrument       - the instrument being telegraphed
%           .channel          - the channels to be scaled
%           .out_gain         - the output gain of the instrument
%           .out_units        - the output units of the amplifier
%           .in_gain          - the input gain of the instrument
%           .in_units         - the input units of the instrument
%
% $Id: telegraphresults_struct.m,v 1.1 2006/01/31 20:00:22 meliza Exp $

fields  = {'instrument', 'channel', 'out_gain', 'out_units',...
           'in_gain', 'in_units'};
C       = {'','',[],'',[],''};
req     = size(fields,2);

S       = StructConstruct(fields, C, req, varargin);
