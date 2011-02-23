function [wvfrm] = PutInputWaveform(instrument, sig_len, wvfrm)
%
% PUTINPUTWAVEFORM  Preloads values from a waveform object into an
% instrument's input channels.
%
% wvfrm = PUTINPUTWAVEFORM(instrument, length, wvfrm)
%
% Uses <wvfrm> to generate a data signal for the input type channels on
% 'instrument'. When the next sweep starts this signal will be sent to the
% inputs of the (real) instrument.  Uses the queue on the waveform object,
% so the updated object is returned by this function.  The signal generated
% will be <length> milliseconds long.
%
% On occasion the number of channels defined in a waveform will not match
% the number of channels we have to fill; this generally happens when a
% waveform is loaded that was created for a different instrument. If the
% waveform has too many channels, the extras are discarded. If it has too
% few, the instrument channels use their default values instead of the
% waveform. A warning is thrown so the user will do something about it,
% hopefully.
%
% See also: DAQDEVICE/PUTDATA, PUTINPUTDATA
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin < 3 || ~ischar(instrument) || ~isa(wvfrm, 'waveform')
    error('METAPHYS:invalidArgument',...
        '%s requires an instrument name and a waveform object.', mfilename)
end

% the channels on the instrument
out_chans   = GetInstrumentChannelNames(instrument,'input');
n_out_chans = length(out_chans);

% the number of columns we have to send
in_chans    = getchannelnames(wvfrm);
n_in_chans  = length(in_chans);
if n_in_chans > n_out_chans
    warning('METAPHYS:putinputdata:dataDiscarded',...
        'The instrument %s has only %d input channels; %d channels discarded.',...
        instrument, n_out_chans, n_in_chans-n_out_chans)
elseif n_out_chans > n_in_chans
    warning('METAPHYS:putinputdata:dataUnderfull',...
        ['The instrument %s has %d input channels; only %d supplied.\n',...
        'Underfilled channels will use default channel value.'],...
        instrument, n_out_chans, n_in_chans)
end
% try to match channel names with each other
chan_match  = zeros(n_out_chans,1);
for i = 1:n_out_chans
    ind = strmatch(out_chans{i},in_chans,'exact');
    if ~isempty(ind)
        chan_match(i)   = ind(1);
    end
end
% now assign unmatched channels
avail_in_chans  = setdiff(1:n_in_chans, chan_match);
for i = 1:n_out_chans
    if chan_match(i) == 0 && size(avail_in_chans,1) > 0
        chan_match(i)   = avail_in_chans(1);
        avail_in_chans  = setdiff(avail_in_chans, chan_match);
    end
end
% now generate the data. This has to be done one daq at a time because the
% sampling rate may vary between objects
chans   = GetChannelStruct(instrument, out_chans);
% the daq devices we have to send data to
daqs    = unique({chans.daq});

for i = 1:length(daqs)
    % the channels we (presumably) have data for
    [ind cname]    = GetChannelIndices(instrument, daqs{i});
    
    daq     = GetDAQ(daqs{i});
    Fs      = get(daq, 'SampleRate');
    samp    = round(Fs * sig_len / 1000);
    T       = linspace(0, sig_len, samp)';
    % send the default values by, um, default
    defs    = GetDefaultValues(daq);
    daqdata = repmat(defs, size(T));
    
    % process the default values through the waveform
    for j = 1:length(ind)
        % this will NOT be empty unless something is horribly wrong
        out_chan_ind    = strmatch(cname{j}, out_chans);
        in_chan_ind     = chan_match(out_chan_ind);
        if in_chan_ind > 0
            [daqdata(:,j) wvfrm] = transformsignal(wvfrm,...
                T, daqdata(:,j), in_chan_ind);
        end
    end
    
    % send the data to the device
    putdata(daq, daqdata)
end
