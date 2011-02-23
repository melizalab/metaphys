function [] = UpdScaledOutput(ch, results)
%
% UPDSCALEDOUTPUT Updates a scaled output channel based
% on the mode and gain information supplied by telegraph. 
%
% UPDSCALEDOUTPUT(scaled_out, results): Updates the scaled output(s) of the
% amplifier using the values in RESULTS. RESULTS is a structure array; each
% element in the array corresponds to a scaled output. SCALED_OUTPUT is an
% array of analoginput channels.
%
% See also: UPDATETELEGRAPH, ADDINSTRUMENTTELEGRAPH, UPDSCALEDCHANNEL
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ~isa(ch, 'daqchild')
    error('METAPHYS:invalidArgument',...
        '%s only takes analog input channels as arguments.',...
        mfilename)
end

% The linear scaling of a channel is defined by the ratio of the
% SensorRange property to the UnitsRange property.  Note that this doesn't
% actually affect the gain of the DAQ; this is controlled with the
% InputRange property.

sensrange   = get(ch,'SensorRange');
if strcmpi(get(ch.Parent, 'Running'), 'Off')
    set(ch, 'Units', results.out_units)
end
f   = @(x) x ./ results.out_gain;
if iscell(sensrange)
    ur  = cellfun(f, sensrange);
    set(ch, {'UnitsRange'}, ur);
else
    ur  = f(sensrange);
    set(ch, 'UnitsRange', ur);
end
