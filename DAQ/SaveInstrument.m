function [] = SaveInstrument(instrument, filename)
%
% SAVEINSTRUMENT Saves an instrument to an mcf file
%
% SAVEINSTRUMENT(instrument, filename)  Saves the instrument specified by
% <instrument> to the file <filename>
%
%
% $Id: SaveInstrument.m,v 1.2 2006/01/17 18:07:56 meliza Exp $

z.instrument.(instrument) = GetInstrument(instrument);
WriteStructure(filename, z)
DebugPrint('Saved instrument %s to file.', instrument)
