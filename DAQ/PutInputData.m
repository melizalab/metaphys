function [] = PutInputData(instrument, data)
%
% PUTINPUTDATA Preloads values that will go to the instrument's inputs in the
% next sweep.
%
% PUTINPUTDATA(instrument, data) - stores <data> in the daq devices associated
%                              with <instrument>, so that when the next
%                              sweep starts, these values will be output.
%                              <data> must be an NxM array, with M equal to
%                              the number of input channels on the
%                              instrument.
%
% See Also: DAQDEVICE/PUTDATA
%
% $Id: PutInputData.m,v 1.2 2006/01/19 03:14:56 meliza Exp $

% we have to map to hardware indices here
instr   = GetInstrument(instrument);
chans   = StructFlatten(instr.channels);

% only analogoutput channels
types   = {chans.type};
chans   = chans(strmatch('input',types));
n_chans = length(chans);

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
    ind     = GetChannelIndices(instrument, daqs{i});
    
    daq     = GetDAQ(daqs{i});
    % send the default values by, um, default
    defs    = GetDefaultValues(daq);
    daqdata = repmat(defs, size(data,1), 1);
    
    % replace defaults with actual values
    data_ind    = column:column+length(ind)-1;
    if any(data_ind > columns)
        error('METAPHYS:putinputdata:insufficientData',...
            'Not enough data to fill all the device channels')
    end
    daqdata(:,ind)  = data(:,data_ind);
    column  = data_ind+1;
    
    % send the data to the device
    putdata(daq, daqdata)
end

