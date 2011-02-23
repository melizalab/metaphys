function [T] = PutInputData(instrument, data, channel_names)
%
% PUTINPUTDATA Preloads values that will go to the instrument's inputs in the
% next sweep.
%
% T = PUTINPUTDATA(instrument, data) - stores <data> in the daq devices associated
%                              with <instrument>, so that when the next
%                              sweep starts, these values will be output.
%                              <data> must be an NxM array, with M equal to
%                              the number of input channels on the
%                              instrument.
%
% If too few channels are supplied, an error is thrown. If too many, they
% are discarded with a warning. To write a single column data to
% one channel, use the following form:
%
% PUTINPUTDATA(instrument, data, channel_names) - store <data> in
% the daq device associated with <instrument>/<channel_names>. The
% default value is used for all the other channels. <data> must
% have as many columns as <channel_names> has cells.
% 
% Return value is the duration of the loaded data (in ms).
%
% See also: DAQDEVICE/PUTDATA, PUTINPUTWAVEFORM
%
% $Id: PutInputData.m,v 1.3 2006/01/30 20:04:42 meliza Exp $

% we have to map to hardware indices here
instr   = GetInstrument(instrument);
chans   = StructFlatten(instr.channels);

% only analogoutput channels
types   = {chans.type};
chans   = chans(strmatch('input',types));
n_chans = length(chans);
if nargin > 2
  n_chans = length(channel_names);
end

% the number of columns we have to send
columns = size(data, 2);
column  = 1;

if columns < n_chans
    error('METAPHYS:putinputdata:insufficientData',...
        'Instrument %s has %d channels; only %d supplied.',...
        instrument, n_chans, columns)
elseif columns > length(chans)
    warning('METAPHYS:putinputdata:dataDiscarded',...
        'The instrument %s has only %d input channels; %d channels discarded.',...
        instrument, n_chans, columns-n_chans)
end

% the daq devices we have to send data to
daqs    = unique({chans.daq});

for i = 1:length(daqs)
    % the channels we (presumably) have data for
    [ind cname]     = GetChannelIndices(instrument, daqs{i});
    
    daq     = GetDAQ(daqs{i});
    Fs      = get(daq, 'SampleRate') / 1000;
    % send the default values by, um, default
    defs    = GetDefaultValues(daq);
    daqdata = repmat(defs, size(data,1), 1);
    T       = size(data,1) / Fs;

    for j = 1:length(ind)
      if nargin > 2
        % fill by name
        data_ind = strmatch(cname{j}, channel_names, 'exact');
      else
        data_ind = column;
        column = column + 1;
      end
      if ~isempty(data_ind)
        daqdata(:,j) = data(:,data_ind);
      end
    end    
    % send the data to the device
    putdata(daq, daqdata)
end

