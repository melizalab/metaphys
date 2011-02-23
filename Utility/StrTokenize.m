function strings    = StrTokenize(string, delimiter)
%
% STRTOKENIZE Completely de-tokenizes a string
%
% strings = STRTOKENIZE(string, delimiter)
%
% Extracts the elements of a tokenized string. For example,
% STRTOKENIZE('this,that,theother',',') will return
% {'this', 'that', 'theother'}.
%
% Default delimiter is ','
%
% See also: STRREAD
%
% (This function is basically a wrapper for STRREAD)
% 
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ~ischar(string)
    error('METAPHYS:strtokenize',...
        'Input must be a character array')
end
if nargin < 2
    delimiter = ',';
end
strings = strread(string,'%s','delimiter',delimiter);
strings = strings(~cellfun('isempty',strings));
