function out = playmovie_default()
%
% PLAYMOVIE_DEFAULT Returns default parameters for the PLAYMOVIE protocol
%
% See also: PLAYMOVIE
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out = struct('instrument',...
    param_struct('Instrument', 'list', 1, GetInstrumentNames),...
    'data_mode',...
    param_struct('Data Storage', 'list', 1, {'daqfile', 'matfile'}),...
    'movie_repeat',...
    param_struct('Movie Repeats', 'value', 1),...
    'update_rate',...
    param_struct('Update Rate', 'value', 5, [], 'Hz'),...
    'ep_interval',...
    param_struct('Intermovie Interval', 'value', 2000, [], 'ms'),...
    'waveform',...
    param_struct('Command Signal', 'object', waveform, [], [],...
        {@WaveformEditor 'modal'}));
