function instrument = GetInstrument(instrumentnames)
%
% GETINSTRUMENT Returns the instrument structures referred to by their
% tags. 
%
% If an array of instrumentnames are supplied then a structure array
% is returned.  Note that because MATLAB does not pass by reference,
% changes to the structure this function returns are not reflected in the
% control structure. However, if the instrument contains channel objects
% these are passed by reference.
%
%
% instrument = GETINSTRUMENT(instrumentnames)
%
% $Id: GetInstrument.m,v 1.2 2006/01/18 19:01:08 meliza Exp $

if iscell(instrumentnames)
    for i = 1:length(instrumentnames)
        instrument(i)  = getstructure(instrumentnames{i});
    end
else
    instrument     = getstructure(instrumentnames);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function instrument  = getstructure(instrumentname)
global mpctrl
instrumentname  = lower(instrumentname);

if ~isfield(mpctrl.instrument, instrumentname)
    error('METAPHYS:daq:instrumentNotFound',...
        'No instrument %s exists.',instrumentname)
end

instrument = mpctrl.instrument.(instrumentname);
