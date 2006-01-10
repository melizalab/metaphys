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
% $Id: DeleteInstrumentChannel.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

global mpctrl
instrument = lower(instrument);

% Get some data about the channels, names and types
instr   = GetInstrument(instrument);
channames   = get(instr.channels, 'ChannelName');
rents       = get(instr.channels, 'Parent');
if iscell(rents)
    rents   = [rents{:}];
end
chantypes   = get(rents,'Type');

% Figure out which channels to delete. Note the tricky input/output
% relationship between instrument and daq channels.
switch lower(channelname)
    case 'all'
        del     = 1:length(chantypes);
    case 'input'
        del     = strmatch('Analog Output',chantypes);
    case 'output'
        del     = strmatch('Analog Input', chantypes);
    otherwise
        del     = strmatch(channelname, channames);
end

% Delete the selected channels, leaving the complementary set
nodel   = setdiff(1:length(chantypes), del);

% only call delete() on aichannels
reallydelete = strmatch('Analog Input', chantypes{del});
delete(instr.channels(reallydelete));

z       = mpctrl.instrument.(instrument).channels(nodel);
mpctrl.instrument.(instrument).channels = z;
        