function substruct  = StructFlatten(fullstruct)
%
% STRUCTFLATTEN attempts to remove the fieldnames from a structure.
%
% If a structure contains a number of fields, all of which are structures
% with the same fields, the structure can be refactored to be an array of
% structure. This function attempts to do that.  It does this with calls to
% STRUCT2CELL and CAT. If the substructures do not have the same signature
% an error will be thrown.
%
% substruct = STRUCTFLATTEN(fullstruct)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

c   = struct2cell(fullstruct);
try
    substruct   = cat(1, c{:});
catch
    error('METAPHYS:structflatten:heterogenousStrucAssignment',...
        'Attempt to flatten structure with dissimilar substructures.')
end