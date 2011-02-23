function varargout = set(obj, varargin)
%
% SET Sets F21CONTROL object properties
%
% SET(f21ctrl, 'prop1', val1, ['prop2', val2]...) - sets the value of
% 'prop1' to val1, 'prop2' to val2, etc...
%
% PROPS = SET() - returns structure with the object's settable properties
%                 and their valid values.
% 
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

PROPERTIES  = {'frame_rate_factor'};

if nargin == 1
    varargout{1}    = cell2struct({[]}, PROPERTIES, 2);
else
    if mod(nargin, 2) ~= 1
        error('METAPHYS:f21control:invalidArgumentCount',...
            'Wrong number of arguments to SET.')
    end
    for i = 1:((nargin-1)/2)
        prop    = varargin{i*2-1};
        val     = varargin{i*2};
        switch lower(prop)
            case 'frame_rate_factor'
                val = fix(val);
                if val < 1
                    error('METAPHYS:f21control:invalidPropertyValue',...
                        'FrameRateFactor must be a positive nonzero integer.')
                end
                sendcommand(obj, 'frame_rate_factor', val);
            otherwise
                error('METAPHYS:f21control:invalidPropertyName',...
                    '%s is not a valid property name.', prop)
        end
    end
end
