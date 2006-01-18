function [] = LoadInstrument(filename, newname)
%
% LOADINSTRUMENT Loads an instrument structure from an mcf file and
% installs it in the control structure. 
%
% LOADINSTRUMENT(filename, [newname]) - loads instrument from file
% <filename>. If an instrument with the same name exists, it will be
% overwritten.
%
% Note that calling load() on a matfile that contains daqdevice or daqchild
% objects will result in the objects being instantiated, or if they already
% exist, in their properties being modified.  This may create some problems
% with analogoutput objects, and attempting to load the same instrument
% twice will result in instruments having linked channels, so that calling
% DELETE, for example, on one of them, will result in the other
% instrument's channel being deleted as well.
%
% $Id: LoadInstrument.m,v 1.3 2006/01/18 19:01:06 meliza Exp $

error('METAPHYS:deprecatedFunction',...
    '%s is deprecated.', mfilename)

% z   = load('-mat', filename);
% if isfield(z, 'instrument')
%     if isstruct(z.instrument)
%         fieldn  = fieldnames(z.instrument);
%         instrument  = z.instrument.(fieldn{1});
%         if nargin > 1
%             instrument.name = newname;
%         end
%         InitInstrument(instrument);
%     else
%         error('METAPHYS:invalidFile:',...
%             'MCF file does not contain any instruments.')
%     end
% else
%     error('METAPHYS:invalidFile:',...
%         'MCF file does not contain any instruments.')
% end
