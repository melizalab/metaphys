function instruments = GetInstrumentNames()
%
% GETINSTRUMENTNAMES Returns a cell array containing a list of the initialized
% instruments stored in the control structure.
%
% instruments = GETINSTRUMENTNAMES()
%
% $Id: GetInstrumentNames.m,v 1.1 2006/01/10 20:59:50 meliza Exp $
global mpctrl

instruments    = fieldnames(mpctrl.instrument);