function out     = isvalid(obj)
%
% ISVALID Returns true if the waveformevent object is valid (ie will
% generate the right outputs)
%
% bool  = ISVALID(event)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if any(size(obj) > 1)
    error('METAPHYS:invalidArgument',...
        '%s only accepts single %s objects.', mfilename, CLASSNAME);
end

CYCLE_MODES = {'single', 'multi', 'random', 'shuffle'};

out = true;
if ~ischar(obj.cycle_mode) || isempty(strmatch(obj.cycle_mode, CYCLE_MODES))
    out = false;
elseif isempty(obj.onset) || isempty(obj.ampl) || isempty(obj.dur)
    out = false;
end