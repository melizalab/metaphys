function instr  = GetCurrentInstrumentName()
%
% GETCURRENTINSTRUMENTNAME Returns the name of the instrument currently
% selected in the main control window
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

instr    = GetUIParam('metaphys', 'instruments', 'selected');