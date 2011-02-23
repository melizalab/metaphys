function Fs = GetChannelSampleRate(instrument, channel)
%
% GETCHANNELSAMPLERATE Returns the sampling rate of a channel
%
% FS = GETCHANNELSAMPLERATE(instrument, channel) - Returns the sampling
% rate (in samples/second) of the channel <channel> on <instrument>.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

daq     = GetInstrumentChannelProps(instrument, channel, 'Parent');
Fs      = daq.SampleRate;
