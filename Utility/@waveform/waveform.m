function obj    = waveform(varargin)
%
% WAVEFORM Constructor for the waveform class
%
% WAVEFORM({channels}) creates a waveform object which contains the
% channels named in {channels} (with no events)
%
% WAVEFORM({channels}, {events}) creates a waveform object that contains
% the channels {channels}, and in each channel the events in the
% corresponding element of {events}
%
% WAVEFORM('chan1', events1, ['chan2', events2],...) returns a WAVEFORM
% object with N channels. The <events> arguments must be arrays of
% WAVEFORMEVENT objects
% 
%
% $Id: waveform.m,v 1.3 2006/01/30 20:05:03 meliza Exp $

if nargin   == 0
    S   = waveform_struct;
    obj = class(S, CLASSNAME);
elseif isa(varargin{1}, CLASSNAME)
    obj = varargin{1};
elseif isstruct(varargin{1})
    fields  = fieldnames(waveform_struct);
    if all(isfield(varargin{1}, fields))
        obj = class(varargin{1}, CLASSNAME);
    else
        error('METAPHYS:badConstructor',...
            'An invalid constructor was used for class %s', mfilename);
    end
elseif iscell(varargin{1})
    if nargin < 2
        varargin{2} = cell(size(varargin{1}));
    end
    S   = waveform_struct(varargin{1}, varargin{2});
    obj = class(S, CLASSNAME);
else
    if mod(nargin,2) > 0
        error('METAPHYS:badConstructor',...
            'The number of arguments to %() must be even', mfilename)
    end
    V   = remap(varargin, nargin/2, 2);
    S   = waveform_struct(V(:,1), V(:,2));
    obj = class(S, CLASSNAME);
end
