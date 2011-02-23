function [s] = r1_struct(varargin)
%
% R1_STRUCT Constructer for the r1 data structure
%
% r1 structures are used to store data sweeps in response to some
% stimulation. This structure is less strict than R0_STRUCT, since sweeps
% do not have to be of equal length. This is accomplished by storing each
% sweep in a separate structure.
%
% Required fields:
%
% .data       - the response, which is an Nx1 array N samples
% .time       - an Nx1 vector describing the time offset of each 
%               sample (in milliseconds)
% .channel    - the channel name (string)
% .units      - the units of the channel (string)
% .start_time - a serial date number defining the start time of the data
%
% Optional fields:
%
% .instrument - the instrument this data came from
%
% See also: R0_STRUCT
% 
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fields  = {'data','time','channel','units','start_time','instrument'};
C       = {[],[],'','',[],''};
req     = 5;

s       = StructConstruct(fields, C, req, varargin);
