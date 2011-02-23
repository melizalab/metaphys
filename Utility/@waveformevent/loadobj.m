function obj    = loadobj(obj)
%
% LOADOBJ Handles WAVEFORMEVENT objects after loading from disk
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ~isa(obj,CLASSNAME)
    obj.queued_params   = {};
    obj.current_sweep   = [];
    obj = class(obj,CLASSNAME);
end
