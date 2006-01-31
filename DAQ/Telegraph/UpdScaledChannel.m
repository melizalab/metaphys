function [] = UpdScaledChannel(results)
%
% UPDSCALEDCHANNEL Updates one or more channels on an amplifier based
% on the mode and gain information supplied by telegraph. 
%
% UPDSCALEDCHANNEL('instrument', results, {channels}): Updates the scaled
% channels of the amplifier using the values in RESULTS. RESULTS is a
% structure array; each element in the array corresponds to a scaled
% output. SCALED_OUTPUT is a cell array containing the names of the
% channels to be modified.  If the length of RESULTS is only one, it will
% be applied to all the channels specified on SCALED_OUTPUT.
%
% UPDSCALEDCHANNEL is a wrapper for UPDSCALEDOUTPUT and UPDSCALEDINPUT. It
% determines what type each channel is and passes control to the
% appropriate function.
%
% See also: UPDATETELEGRAPH, ADDINSTRUMENTTELEGRAPH, UPDSCALEDOUTPUT,
% UPDSCALEDINPUT
%
% $Id: UpdScaledChannel.m,v 1.2 2006/01/31 22:48:23 meliza Exp $

if isempty(results)
    return
end

for i = 1:length(results)
    chan    = GetInstrumentChannel(results(i).instrument, results(i).channel);
    ctype   = get(chan{1}.Parent, 'Type');
    switch ctype
        case 'Analog Input'
            UpdScaledOutput(chan{1}, results(i));
        case 'Analog Output'
            UpdScaledInput(chan{1}, results(i));
    end
end

