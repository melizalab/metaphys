function obj    = loadobj(obj)
%
% LOADOBJ Handles WAVEFORMEVENT objects after loading from disk
%
% $Id: loadobj.m,v 1.1 2006/01/27 00:40:11 meliza Exp $

if ~isa(obj,CLASSNAME)
    obj.queued_params   = {};
    obj.current_sweep   = [];
    obj = class(obj,CLASSNAME);
end
