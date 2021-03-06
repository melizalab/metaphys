function [] = DeleteTelegraph(instrument, telegraph)
%
% DELETETELEGRAPH Deletes a telegraph from an instrument, along with any
% associated objects or channels.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
global mpctrl

%% Get telegraph structure
telestruct   = GetTelegraph(instrument, telegraph);

%% Delete channel objects
if isfield(telestruct, 'obj')
    obj = telestruct.obj;
    for i = 1:length(obj)
        if isa(obj(i), 'daqchild')
            p   = obj(i).Parent;
            DebugPrint('Destroying daqchild %s/%s', p.Name,...
                obj(i).ChannelName);
            delete(obj(i));
        end
    end
end
%% Clear control field
mpctrl.instrument.(instrument).telegraph = ...
    rmfield(mpctrl.instrument.(instrument).telegraph, telegraph);
if length(fieldnames(mpctrl.instrument.(instrument).telegraph)) < 1
    mpctrl.instrument.(instrument).telegraph = [];
end
DebugPrint('Deleted telegraph %s/%s.', instrument, telegraph);