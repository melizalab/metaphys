function [s, fields] = param_struct()
%
% PARAM_STRUCT Header for the parameter structure. 
%
% Defines the param structure (by returning a structure with the proper
% fields) The parameter structure is used to define an experimental
% parameter that can be manipulated with the PARAMFIGURE figure or the
% GETPARAM and GETPARAM functions.
%
% Required fields:
%
% m.description - a 'friendly' description of the parameter 
%                 (e.g. 'Number of Repeats')
% m.fieldtype   - the type of parameter this is.  Can be any of the following:
%                 {'String', 'Value', 'List', 'Hidden', 'File_in', or 'Fixed'}
% 
%
% Optional fields:
% m.value       - the current (or default) value of the parameter
% m.choices     - required for fieldtype=='List', describes the acceptable 
%                 values of the param
% m.units       - the units of the parameter
% m.callback    - if this is supplied for 'Value' or 'String',
%                 altering the value in the field will call the callback
%                 for fixed, a button will be created with the callback
%
%                 The file_in fieldtype is a specific instance of the fixed fieldtype
%                 in which the callback is a file selection function implemented by
%                 PARAMFIGURE. Thus, this value will be overwritten.
%
% See Also: PARAMFIGURE, GETPARAM
%
% $Id: param_struct.m,v 1.1 2006/01/10 20:59:52 meliza Exp $

fields = {'description','fieldtype','value','choices','units','callback'};
C      = {'','',[],{},'',[]};
s      = cell2struct(C, fields, 2);
