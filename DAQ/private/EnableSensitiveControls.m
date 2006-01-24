function [] = EnableSensitiveControls(mode)
%
% ENABLESENSTIVECONTROLS Turn on or off sensitive controls
%
% $Id: EnableSensitiveControls.m,v 1.1 2006/01/25 01:31:37 meliza Exp $
OBJECTS = {'data_dir_select', 'protocol_select', 'instrument_add',...
    'instrument_edit','instrument_delete','seal_test','protocol_init',...
    'protocol_start','protocol_record','properties_digitizer'};
h   = GetUIHandle('metaphys',OBJECTS);
set(h,'Enable',mode)

h   = GetUIHandle('metaphys','inputs_pnl');
k   = findobj(h,'style','edit');
set(k,'enable',mode)
