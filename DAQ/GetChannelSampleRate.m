function Fs = GetChannelSampleRate(instrument, channel)
%
% GETCHANNELSAMPLERATE Returns the sampling rate of a channel
%
% FS = GETCHANNELSAMPLERATE(instrument, channel) - Returns the sampling
% rate (in samples/second) of the channel <channel> on <instrument>.
%
% $Id: GetChannelSampleRate.m,v 1.1 2006/01/19 03:14:54 meliza Exp $

daq     = GetInstrumentChannelProps(instrument, channel, 'Parent');
Fs      = daq.SampleRate;
