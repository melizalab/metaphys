function varargout = getvaluerotation(obj, varargin)
%
% GETVALUEROTATION Returns the actual values of the parameters for each
% trial
%
% [onset, ampl, dur] = GETVALUEROTATION(event,[nval]) returns the values, 
%             in ms, channel units, and ms, respectively, of the onset,
%             amplitude, and duration parameters. 
%
% [params]  = GETVALUEROTATION(event,[nval]) returns all the values in a single
%             NxM matrix. If the parameter function return single values,
%             M will be 3; otherwise it will be the sum of the number of
%             values returned by each parameter function (in the order
%             above)
%
% The argument <nval> is used only when the cycle_mode is 'random'. See
% GETPARAMROTATION.
%
% See Also: WAVEFORMEVENT/GETPARAMROTATION
%
% $Id: getvaluerotation.m,v 1.2 2006/01/27 00:40:11 meliza Exp $

fields  = FIELDS;

inputs  = cell(size(fields));
outputs = cell(size(fields));

[inputs{:}] = getparamrotation(obj, varargin{:});

for i = 1:length(fields)
    paramf  = getfunc(obj, fields{i});
    if isempty(paramf)
        outputs{i}  = inputs{i};
    else
        outputs{i}  = paramf(inputs{i});
    end
end

if nargout > 1
    varargout = outputs;
else
    varargout{1}    = cell2mat(outputs);
end
