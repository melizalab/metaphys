function [] = SaveInstrument(instrument, filename)
%
% SAVEINSTRUMENT Saves an instrument to an mcf file
%
% SAVEINSTRUMENT(instrument, filename)  Saves the instrument specified by
% <instrument> to the file <filename>
%
%
% $Id: SaveInstrument.m,v 1.3 2006/01/18 19:01:06 meliza Exp $

error('METAPHYS:deprecatedFunction',...
    '%s is deprecated.' mfilename)
% 
% z.instrument.(instrument) = GetInstrument(instrument);
% WriteStructure(filename, z)
% DebugPrint('Saved instrument %s to file.', instrument)
