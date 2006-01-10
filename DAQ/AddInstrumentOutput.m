function c = AddInstrumentOutput(instrument, daqname, hwchannel, outputname, varargin)
%
% ADDINSTRUMENTOUTPUT Adds an output to an instrument. 
%
% Each output is associated with an analoginput channel on the DAQ hardware
% and is basically an aichannel object.  Multiple aichannel objects can be
% associated with a single hardware channel on a device, which allows the
% same data to be read with different units or gain.
%
% chan = ADDINSTRUMENTOUTPUT(instrument, daqname, hwchannel, outputname, [props])
%
% instrument - the name of an instrument in the control structure
% daqname    - the name of a daq device
% hwchannel  - the hardware channel (generally the BNC port number)
% outputname - the name of the output
% props      - channel properties to set on the new channel
%
% chan       - returns a pointer to the new channel
%
% See also INITINSTRUMENT, ADDINSTRUMENTINPUT
%
% $Id: AddInstrumentOutput.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

global mpctrl

if ~isfield(mpctrl.instrument, instrument)
    error('METAPHYS:daq:noSuchInstrument',...
        'No such instrument %s has been defined.', instrument)
end

daq = GetDAQ(daqname);
c   = addchannel(daq, hwchannel, outputname);
set(c,varargin{:})

mpctrl.instrument.(instrument).channels.(outputname)    = c;

    