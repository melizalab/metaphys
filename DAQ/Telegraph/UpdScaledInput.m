function [] = UpdScaledInput(ch, results)
%
% UPDSCALEDINPUT    Updates a scaled input channel based on the mode and
% gain information supplied by telegraph. 
%
% UPDSCALEDOUTPUT(scaled_in, results): Updates the scaled input of the
% amplifier using the values in RESULTS. RESULTS is a structure array; each
% element in the array corresponds to a scaled output. SCALED_IN is an
% array of analogoutput channels.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ~isa(ch, 'daqchild')
    error('METAPHYS:invalidArgument',...
        '%s only takes analog input channels as arguments.',...
        mfilename)
end

% The linear scaling of a channel is defined by the ratio of the
% OutputRange property to the UnitsRange property.  

range   = get(ch,'OutputRange');
if strcmpi(get(ch.Parent, 'Running'), 'Off')
    set(ch, 'Units', results.in_units)
end
f   = @(x) x ./ results.in_gain;
if iscell(range)
    ur  = cellfun(f, range);
    set(ch, {'UnitsRange'}, ur);
else
    ur  = f(range);
    set(ch, 'UnitsRange', ur);
end