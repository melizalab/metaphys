function packet = DAQ2Packet(fn, channels, instrumenttype, scaledchannels)
%
% DAQ2PACKET    Converts a daq file into packets
%
% P = DAQ2PACKET(fn, [channels], [instrumenttype, scaledchannels])
%
% fn        - the filename to read in (one only)
% channels  - the channels to keep. If empty or not supplied, keep all
%             except telegraph lines
% instrumenttype -
%             the type of instrument that produced the data. This needs to 
%             be specified in order to determine what the telegraphs mean.
%             Can be '200x' or '1x'
% scaledchannels - 
%             the channels to attempt to scale using telegraph data. If no
%             telegraph data exists, this argument has no effect
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

info        = GetDAQHeader(fn);
[d t at]    = daqread(fn);

if nargin > 2 && ~isempty(instrumenttype) && ~isempty(info.gain)
    for i = scaledchannels
        c_units = info.channels(i).Units;
        c_scale = GetChannelGain(info.channels(i)); % (units/V)
        gain_v  = mean(d(:,info.gain));
        if isempty(info.mode)
            [in out]    = CalcGain(instrumenttype, c_units, c_units, gain_v);
        else
            mode_v          = mean(d(:,info.mode));
            mode            = CalcMode(instrumenttype, mode_v(1:length(scaledchannels)));
            [in_u out_u]    = CalcUnits(instrumenttype, mode);
            % (V/units)
            [in out]        = CalcGain(instrumenttype, in_u, out_u, gain_v(1:length(scaledchannels)));
            c_units         = out_u;
        end
        info.channels(i).Units  = c_units;
        % old_units / (old_units/V) / (V/new_units) = new_units
        d(:,i)                  = d(:,i) ./ c_scale ./ out;
    end
end

chan_ind    = 1:length(info.channel_names);
if nargin < 2 || isempty(channels)
    channels    = setdiff(chan_ind, [info.gain;info.mode]); % J [,]changed 06.27.06
else
    channels    = intersect(channels, chan_ind);
end
units   = {info.channels.Units};
packet  = packet_struct('', '',...
                        info.channel_names(channels), ...
                        units(channels), ...
                        d(:,channels), ...
                        t, ...
                        datenum(at), ...
                        info);

                        