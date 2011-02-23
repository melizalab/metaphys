function [n_disp_obj] = getobjectcount(obj)
%
% GETOBJECTCOUNT Retrieves the # of display objects. F21mvx only.
%
% If the remote program is f21mv:
% [nobjs] = GETOBJECTCOUNT(obj)
%
% Throws an error if the remote program is f21mv
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

remote  = get(obj, 'project_name');
switch lower(remote)
    case 'f21mv'
        error('METAPHYS:f21control:unsupportedOperation',...
            'Remote program is f21: only one object');
    case 'f21mvx'
        out     = sendrequest(obj, 'sti_get_val', 'number_obj');
end

tok     = StrTokenize(out);
if strcmpi(tok{2},'failed')
    error('METAPHYS:f21control:commandFailed',...
        'Failed to retrieve object count from f21: %s', out);
end
n_disp_obj = str2double(tok{2});
