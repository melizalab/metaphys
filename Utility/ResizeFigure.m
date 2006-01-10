function [] = ResizeFigure(varargin)
%
% RESIZEFIGURE Resizes a figure window while keeping it in place.
%
%   [] = RESIZEFIGURE([x y])  resizes the current figure to X inches by Y inches
%   [] = RESIZEFIGURE([x y], units)  resizes the current figure to X units by Y
%   units.
%
%   [] = RESIZEFIGURE(h,...)  resizes the figure given by the handle H
%
% $Id: ResizeFigure.m,v 1.1 2006/01/10 20:59:53 meliza Exp $
UNITS   = 'inches';

error(nargchk(1,3,nargin))

if ishandle(varargin{1})
    f   = varargin{1};
    p   = varargin{2};
    if nargin == 3
        UNITS   = varargin{3};
    end
else
    f   = gcf;
    p   = varargin{1};
    if nargin > 1
        UNITS   = varargin{2};
    end
end

set(f,'Units',UNITS);
current = get(f,'Position');
set(f,'Position',[current(1) current(2) p(1) p(2)]);