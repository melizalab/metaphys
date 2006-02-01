function y = wmean(x, w)
%WMEAN   Weighted average or mean value.
%   For vectors and matrices, WMEAN(X,W) is the mean value of the 
%   elements in X, with each element having a weight equal to the
%   value of the corresponding element in W (which must be the same
%   size.
%
%   

%   See also MEAN. 
%   $Revision: 1.1 $  $Date: 2006/02/01 19:27:57 $

error(nargchk(2,2,nargin))

if ndims(x) ~= ndims(w)
    error('Matrices must have the same number of dimensions');
end
if any(size(x) ~= size(w))
    error('Matrices must be the same size.');
end

xw  = x .* w;
for i = 1:ndims(xw)
    xw   = sum(xw,i);
    w    = sum(w,i);
end
y   = xw / w;