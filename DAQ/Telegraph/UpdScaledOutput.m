function [] = UpdScaledOutput(instrument, results, scaled_out)
%
% UPDSCALEDOUTPUT Updates one or more scaled outputs on an amplifier based
% on the mode and gain information supplied by telegraph. 
%
% UPDSCALEDOUTPUT(instrument, results, scaled_out): Updates the scaled
% output(s) of the amplifier using the values in RESULTS. RESULTS is a
% structure array; each element in the array corresponds to a scaled
% output. SCALED_OUTPUT is a cell array containing the names of the
% channels to be modified.  If the length of RESULTS is only one, it will
% be applied to all the channels specified on SCALED_OUTPUT.
%
%
%
% See Also: UPDATETELEGRAPH, ADDINSTRUMENTTELEGRAPH
%
% $Id: UpdScaledOutput.m,v 1.1 2006/01/10 20:59:51 meliza Exp $

% Get the channels
chan        = GetInstrumentChannel(instrument, scaled_out);

% Now update the output properties
% The linear scaling of a channel is defined by the ratio of the
% SensorRange property to the UnitsRange property.  Note that this doesn't
% actually affect the gain of the DAQ; this is controlled with the
% InputRange property.
if length(results) < length(chan)
    results = repmat(results, length(chan), 1);
end

for i = 1:length(chan)
    sensrange   = get(chan(i),'SensorRange');
    set(chan(i), 'Units', results(i).units,...
        'UnitsRange', sensrange .* results(i).gain);
end
