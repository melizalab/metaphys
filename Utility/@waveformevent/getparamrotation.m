function varargout = getparamrotation(obj, nval)
%
% GETPARAMROTATION Returns the rotation of parameter values for a
% waveformevent
%
% [onset ampl duration]  = GETPARAMROTATION(event,[nval])
%
% If cycle_mode is 'random', <nval> controls how many trials will be
% returned. In other modes this argument is ignored. If the argument is not
% supplied the default number of trials will be returned (10).
%
% each of the parameters is an NxM array, with N being the number of trials
% and M the number of values in the parameter (for complex parameters)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

NVAL    = 10;

if any(size(obj) > 1)
    error('METAPHYS:invalidArgument',...
        '%s only accepts single %s objects.', mfilename, CLASSNAME);
elseif ~isvalid(obj)
    error('METAPHYS:invalidObject',...
        'The %s object is not valid', CLASSNAME)
end
fields      = FIELDS;
varargout   = cell(size(fields));
params      = getparameters(obj, fields);
paramsz     = cellfun('size',params,1);

switch lower(obj.cycle_mode)
    case 'single'
        min_len = min(paramsz);
        for i = 1:length(fields)
            varargout{i}    = obj.(fields{i})(1:min_len,:);
        end
    case 'multi'
        % compute the lcm, which is the minimum length of rotation
        lc  = multilcm(paramsz);
        fac = lc ./ paramsz;
        for i = 1:length(fields)
            varargout{i}    = repmat(obj.(fields{i}), fac(i), 1);
        end
    case 'random'
        if nargin > 1
            NVAL = nval;
        end
        for i = 1:length(fields)
            pick            = unidrnd(paramsz(i),NVAL,1);
            varargout{i}    = obj.(fields{i})(pick,:);
        end
    case 'shuffle'
        lc  = multilcm(paramsz);
        fac = lc ./ paramsz;
        for i = 1:length(fields)
            ind             = shuffledsequence(paramsz(i), fac(i));
            ind             = reshape(ind, numel(ind), 1);
            varargout{i}    = obj.(fields{i})(ind,:);
        end
end
    