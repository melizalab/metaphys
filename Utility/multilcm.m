function V = multilcm(V)
%
% MULTILCM returns the least common multiple of an array of positive
% integers
%
% m = MULTILCM(V) is the least common multiple of all the values in V. The
% array V must contain only positive integers
%
% Recursively calls LCM until there is only one number left
%
% $Id: multilcm.m,v 1.2 2006/01/30 20:05:03 meliza Exp $

if any(V < 1 | fix(V) ~= V)
    error('METAPHYS:multilcm:InputNotPosInt',...
          'Input arguments must contain positive integers.')
end

V   = V(:);
lV  = size(V,1);
while lV > 1
    V   = [V; ones(mod(lV,2),1)];
    V   = reshape(V, size(V,1)/2, 2);
    V   = lcm(V(:,1), V(:,2));
    lV  = size(V,1);
end
