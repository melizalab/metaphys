function props = GetInstrumentChannelProps(instrument, channame, varargin)
%
% GETINSTRUMENTCHANNELPROPS Changes properties of an instrument channel. 
%
% Used like GET, but with the names of the instrument and channel instead
% of a pointer. Multiple properties can be got with a comma-separated list.
% If no properties are supplied, a list of gettable properties is returned.
%
% props = GETINSTRUMENTCHANNELPROPS(instrument, channame) returns a cell array
%         of properties on the named channel.
%
% [] = GETINSTRUMENTCHANNELPROPS(instrument, channame, props...) returns
%      the values of the properties. <props> can be a single string, a cell
%      array of strings, or a comma-separated list
%
% instrument - the name of an instrument in the control structure
% channame   - the name of the channel (input or output)
% props      - channel properties to set on the new channel
%
%
% See also INITINSTRUMENT, ADDINSTRUMENTINPUT, DAQCHILD/GET
%
% $Id: GetInstrumentChannelProps.m,v 1.1 2006/01/11 23:03:56 meliza Exp $

chan    = GetInstrumentChannel(instrument, channame);

props   = get(chan, varargin{:});


    