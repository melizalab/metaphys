function name   = NewInstrumentName(base_name)
%
% NEWINSTRUMENTNAME Returns a unique name for a new instrument. 
%
% NEWINSTRUMENT([base_name]) - returns the first name of the form
% '<base_name>_n' that is not currently in use. <base_name> defaults to
% 'newinstrument'
%
% The user can, of course, change this later
%
% $Id: NewInstrumentName.m,v 1.1 2006/01/11 03:19:59 meliza Exp $
BASE_NAME = 'newinstrument';
if nargin > 0
    BASE_NAME = base_name;
end
index     = 1;

instruments = GetInstrumentNames;
while 1
    name    = sprintf('%s_%d', BASE_NAME, index);
    if isempty(instruments) | isempty(strmatch(name, instruments))
        return
    else
        index   = index+1;
    end
end