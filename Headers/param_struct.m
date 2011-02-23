function [S] = param_struct(varargin)
%
% PARAM_STRUCT Header for the parameter structure. 
%
% Defines the param structure. The parameter structure is used to define an
% experimental parameter that can be manipulated with the PARAMFIGURE
% figure or the GETPARAM and GETPARAM functions.
%
% S = PARAM_STRUCT  - returns an empty structure
% S = PARAM_STRUCT(description, fieldtype, [value], [choices], [units],...
%                  [callback)
%
% Required fields:
%
% m.description - a 'friendly' description of the parameter 
%                 (e.g. 'Number of Repeats')
% m.fieldtype   - the type of parameter this is.  Can be any of the following:
%                 {'String', 'Value', 'List', 'Hidden', 'File_in',
%                  'Fixed', or 'Object'}
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
%                 The object fieldtype is a special instance of the
%                 'string' fieldtype but where an underlying object is used
%                 to hold and handle the string. In order to be used by
%                 PARAMFIGURE, the object must have a CHAR method and have
%                 a constructor that takes a single string parameter. For
%                 instance, the F21CONTROL class returns the remote host
%                 address when CHAR is called, and will construct a new
%                 F21CONTROL with a single string argument.  
%
%
% See also: PARAMFIGURE, GETPARAM
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fields = {'description','fieldtype','value','choices','units','callback'};
C      = {'','',[],{},'',[]};

S      = StructConstruct(fields, C, 2, varargin);
