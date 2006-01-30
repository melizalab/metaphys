function [] = WriteProtocolData(varargin)
%
% WRITEPROTOCOLDATA     Outputs protocol data to disk prior to beginning
% acquisition.
%
% WRITEPROTOCOLDATA('module')    Writes the parameters for the module to
% disk in the current data acquisition directory. The structure is stored
% as 'module-params.mat' and can be loaded by PARAMFIGURE
%
% WRITEPROTOCOLDATA('module', data)  In addition to the module parameters,
% writes the contents of <data> to disk. The data is stored in a parameter
% called 'userdata'.
%
% $Id: WriteProtocolData.m,v 1.1 2006/01/30 19:23:05 meliza Exp $

FILENAME    = '%s-params.mat';

if nargin < 1 || nargin > 2 || ~ischar(varargin{1})
    error('METAPHYS:writeprotocoldata:invalidArguments',...
        'Invalid arguments for call to %s. Check usage.', mfilename)
end

% Retrieve data directory
ddir    = GetDataStorage;
if isempty(ddir)
    DebugPrint('System not set to log data. No protocol information written.')
else
    module  = lower(varargin{1});
    params  = GetParam(module);
    if nargin > 1
        params.userdata = param_struct('protocol userdata', 'hidden', varargin{2});
    end
    pnfn    = fullfile(ddir, sprintf(FILENAME, module));
    WriteStructure(pnfn,params);
    DebugPrint('Wrote protocol data to %s.', pnfn)
end
