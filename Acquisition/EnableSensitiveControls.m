function [] = EnableSensitiveControls(mode)
%
% ENABLESENSITIVECONTROLS Turn on or off sensitive controls
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

    PROT_OBJS   = {'protocol_start','protocol_record'};
    OBJECTS = {'data_dir_select', 'protocol_select', 'instrument_add',...
        'instrument_edit','instrument_delete','seal_test','protocol_init',...
        'protocol_start','protocol_record','properties_digitizer'};
try
    h   = GetUIHandle('metaphys',OBJECTS);
    set(h,'Enable',mode)
    if strcmpi(mode,'on') && isempty(GetCurrentProtocol)
        h   = GetUIHandle('metaphys',PROT_OBJS);
        set(h,'enable','off')
    end

    h   = GetUIHandle('metaphys','inputs_pnl');
    k   = findobj(h,'style','edit');
    set(k,'enable',mode)
catch
    DebugPrint('Couldn''t find metaphys window');
end