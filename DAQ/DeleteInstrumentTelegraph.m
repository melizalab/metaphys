function [] = DeleteInstrumentTelegraph(instrument, telegraph)
%
% DELETEINSTRUMENTTELEGRAPH Removes a telegraph from an instrument. 
%
% If there are any instrumentchannels associated with the telegraph, they
% are deleted, and the telegraph structure is removed from the instrument
% control tree. This will prevent UPDATELEGRAPH from trying to read these
% channels.
%
% DELETEINSTRUMENTTELEGRAPH(instrument, telegraph) - removes the named
%                                                    telegraph(s)
% DELETEINSTRUMENTTELEGRAPH(instrument, 'all') - removes all telegraphs
%
% See also UPDATETELEGRAPH
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ischar(telegraph)
    if strcmpi(telegraph, 'all')
        telegraph   = GetInstrumentTelegraphNames(instrument);
    else
        telegraph   = {telegraph};
    end
end
for i = 1:length(telegraph)
    DeleteTelegraph(instrument, telegraph{i});
end