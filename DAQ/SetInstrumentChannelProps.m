function props = SetInstrumentChannelProps(instrument, channame, varargin)
%
% SETINSTRUMENTCHANNELPROPS Changes properties of an instrument channel. 
%
% Used like SET, but with the names of the instrument and channel instead
% of a pointer. Multiple properties can be set with a comma-separated list.
% If no properties are supplied, a list of settable properties is returned.
%
% props = SETINSTRUMENTCHANNELPROPS(instrument, channame) returns a cell array
% of properties that can be set on the named channel.
%
% [] = SETINSTRUMENTCHANNELPROPS(instrument, channame, props...) sets the
% property/ies of the channel to the values specified.
%
% instrument - the name of an instrument in the control structure
% channame   - the name of the channel (input or output)
% props      - channel properties to set on the new channel
%
%
% See also INITINSTRUMENT, ADDINSTRUMENTINPUT, DAQCHILD/SET
%
% $Id: SetInstrumentChannelProps.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

chan    = GetInstrumentChannel(instrument, channame);

if nargin < 3
    props   = set(chan);
else
    props   = [];
    set(chan, varargin{:});
end


    