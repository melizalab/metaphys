function [] = DeleteModule(module)
%
% DELETEMODULE Removes a module from the control structure and deletes
% its associated figure(s).
%
% [] = DELETEMODULE(module)
%
% module (String) - module name
%
% $Id: DeleteModule.m,v 1.6 2006/01/27 23:46:41 meliza Exp $

global mpctrl

module  = lower(module);

if isfield(mpctrl,module)
    % Call the object's destructor
    try
        if exist(module,'file') > 0
            warning('off','MATLAB:dispatcher:InexactCaseMatch')
            feval(module, 'destroy')
            warning('on','MATLAB:dispatcher:InexactCaseMatch')
        end
    end

    try
        % Delete the figure
        fig = mpctrl.(module).fig;
        delete(fig(ishandle(fig)))
    end

    try
        % Delete parameter figures
        fig = FindFigure([module '.param']);
        delete(fig(ishandle(fig)))
    end

    % Clear the module from control
    mpctrl = rmfield(mpctrl, module);
    DebugPrint('Deleted module %s.', module)
end
try
    % Delete any orphans
    fig = FindFigure(module);
    delete(fig(ishandle(fig)))
end
