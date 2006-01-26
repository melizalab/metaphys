function instr  = GetCurrentInstrumentName()
%
% GETCURRENTINSTRUMENTNAME Returns the name of the instrument currently
% selected in the main control window
%
% $Id: GetCurrentInstrumentName.m,v 1.1 2006/01/26 23:37:23 meliza Exp $

instr    = GetUIParam('metaphys', 'instruments', 'selected');