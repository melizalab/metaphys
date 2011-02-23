function [] = DeleteInstrumentChannel(instrument, channelname)
%
% DELETEINSTRUMENTCHANNEL Removes an input or output from an instrument in
% the control structure. 
%
% For instrumentoutputs, also deletes that channel from the associated DAQ
% object.
%
% DELETEINSTRUMENTCHANNEL(instrument, channelname) - Removes the channel
% with the name CHANNELNAME from the instrument INSTRUMENT.  Throws an
% error if either of these values are invalid.
%
% DELETEINSTRUMENTCHANNEL(instrument, 'all') - Deletes all channels.
% DELETEINSTRUMENTCHANNEL(instrument, 'input') - Deletes all input channels.
% DELETEINSTRUMENTCHANNEL(instrument, 'output') - Deletes all output channels.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

instrument = lower(instrument);

switch lower(channelname)
    case {'all','input','output'}
        channelname  = GetInstrumentChannelNames(instrument, channelname);
    otherwise
        channelname  = {channelname};
end

for i = 1:length(channelname)
    DeleteChannel(instrument, channelname{i});
end
