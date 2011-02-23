function varargout = SetInstrumentChannelProps(instrument, channame, varargin)
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
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

chan    = GetInstrumentChannel(instrument, channame);

if length(chan) > 1
    error('METAPHYS:invalidArgument',...
        '%s only sets properties on one channel', mfilename)
end

if nargin < 3
    varargout   = {set(chan{:})};
else
    varargout   = {};
    set(chan{:}, varargin{:});
end


    