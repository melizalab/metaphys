function WriteStructure(writestruct_filename_12312, wstruct_structure_13244)
%
% WRITESTRUCTURE Writes a structure to a mat file. 
%
% The fields of the
% structure are stored individually in the file, so that the command str =
% load(filename) will reconstruct the structure.  Due to the way load()
% works, it is not possible to do this with a structure array in which any
% of the dimensions have a size > 1.  If data of this type needs to be
% stored, use save() or refactor the data so that multiple entries are
% stored in cell and numerical arrays.
%
% Usage:
% WRITESTRUCTURE(filename, structure)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% Note: the reason the variable names are so obfuscated is to avoid
% situations where the fieldname is the same as a variable in the
% workspace.

%% Check arguments
if nargin < 2
    error('METAPHYS:writestructure:invalidUsage',...
        'Usage: WriteStructure(filename, structure)')
end
if ~isa(wstruct_structure_13244,'struct')
    error('METAPHYS:writestructure:invalidArgument',...
        'Input must be a structure.')
end
if any(size(wstruct_structure_13244)>1)
    error('METAPHYS:writestructure:invalidDimensions',...
        'Structure dimensions must be 1x1.')
end

%% Remap the structure into independent variables
wstruct_fieldnames_1324128 = fieldnames(wstruct_structure_13244);
for wstruct_index_3463 = 1:length(wstruct_fieldnames_1324128)
    wstruct_varname_3431 = wstruct_fieldnames_1324128{wstruct_index_3463};
    wstruct_sf_7278276 = sprintf('%s = wstruct_structure_13244.%s;',...
        wstruct_varname_3431,wstruct_varname_3431);
    eval(wstruct_sf_7278276);
end
save(writestruct_filename_12312,wstruct_fieldnames_1324128{:});
