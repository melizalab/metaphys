function [] = SaveInstrument(instrument, filename)
%
% SAVEINSTRUMENT Saves an instrument to an mcf file
%
% SAVEINSTRUMENT(instrument, filename)  Saves the instrument specified by
% <instrument> to the file <filename>
%
%
% $Id: SaveInstrument.m,v 1.1 2006/01/14 00:48:10 meliza Exp $

z.instrument.(name) = GetInstrument(instrument);
WriteStructure(fullfile(pn, fn), z)
