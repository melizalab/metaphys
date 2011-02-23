function defaults = GetDefaultValues(daq)
%
% GETDEFAULTVALUES Returns the default values of the channels on a DAQ
% object
%
% V = GETDEFAULTVALUES(daqname) returns a 1xN array of values, which are
% the values of the DefaultChannelValue property for each of the channels
% defined on <daqname>. If the daq has no channels, or is not an
% analoginput device, V is empty.
%
% V = GETDEFAULTVALUES(daq) returns a 1xN array of values, which are
% the values of the DefaultChannelValue property for each of the channels
% defined on the object <daq>.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

defaults    = [];
if ischar(daq)
    daq    = GetDAQ(daq);
end
if ~isempty(daq)
    if strcmpi('analog output', daq.Type)
        defaults    = get(daq.Channel, 'DefaultChannelValue');
        if iscell(defaults)
            defaults    = cell2mat(defaults)';
        end
    end
end
