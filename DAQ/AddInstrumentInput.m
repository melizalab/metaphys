function [] = AddInstrumentInput(instrument, daqname, hwchannel, inputname, varargin)
%
% ADDINSTRUMENTINPUT Adds an input to an instrument. 
%
% Each input is associated with an analogoutput channel on the DAQ hardware
% and is basically an aochannel object.  Only one aochannel can be
% associated with a single hardware channel (MATLAB will let you do this,
% but an error will be thrown when the device is started); however,
% multiple instrumentinputs can be associated with a single aochannel
% object.
%
% ADDINSTRUMENTINPUT(instrument, daqname, hwchannel, outputname, [props])
%
% instrument - the name of an instrument in the control structure
% daqname    - the name of a daq device
% hwchannel  - the hardware channel (generally the BNC port number)
% outputname - the name of the output
% props      - channel properties to set on the new channel
%
% See also INITINSTRUMENT, ADDINSTRUMENTOUTPUT, PRIVATE/ADDCHANNEL
%
% $Id: AddInstrumentInput.m,v 1.5 2006/01/30 19:23:05 meliza Exp $

daq = GetDAQ(daqname);

% Check to see if an aochannel has already been defined for this DAQ:
chan     = get(daq,'Channel');
hwchans  = get(chan,'HwChannel');
if iscell(hwchans)
    hwchans = cell2mat(hwchans);
end

if any(hwchans==hwchannel)
    % If the channel already exists, a reference to the existing object is
    % added to the control struct. This means that all the properties of
    % the instrumentinputs associated with an aochannel will be linked.
    % This may create some problems if the same aochannel is used with
    % multiple instruments, and with different gains: need to store some
    % virtual gain information.
    c   = chan(hwchans==hwchannel);
else
    c   = addchannel(daq, hwchannel, inputname);
end

set(c,'OutputRange',[-10 10],'UnitsRange',[-10 10],...
    'Units', 'V');
set(c,varargin{:})
AddInstrumentChannel(instrument, inputname, c)
