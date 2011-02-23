function obj    = waveformevent(varargin)
%
% WAVEFORMEVENT Constructor for the waveformeevent class
%
% obj   = WAVEFORMEVENT(onsets, amplitudes, durations) - constructs a
%                   waveformevent object (minimum required arguments)
%
% obj   = WAVEFORMEVENT(onsets, amplitudes, durations, [cycle_mode],...
%                       [onset_func], [amplitude_func], [duration_func])
%
% See also: WAVEFORMEVENT_STRUCT
% 
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin   == 0
    S   = waveformevent_struct;
    obj = class(S, CLASSNAME);
elseif isa(varargin{1}, CLASSNAME)
    obj = varargin{1};
elseif isstruct(varargin{1})
    fields  = fieldnames(waveformevent_struct);
    if all(isfield(varargin{1}, fields))
        obj = class(varargin{1}, CLASSNAME);
    else
        error('METAPHYS:badConstructor',...
            'An invalid constructor was used for class %s', mfilename);
    end
else
    S   = waveformevent_struct(varargin{:});
    obj = class(S, CLASSNAME);
end
