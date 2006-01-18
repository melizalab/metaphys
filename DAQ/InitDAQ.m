function [daq, daqname] = InitDAQ(hwname, hwnumber, constructor, varargin)
%
% INITDAQ Initializes data acquisition hardware and stores the associated
% objects in the control structure. 
%
% This function uses the constructors supplied by DAQHWINFO to initialize
% the drivers, and then generates an appropriate name to store the object
% as in the control structure. These names have the general form
% <hwname>_<hwid>_<daqtype>
%
% [daq, daqname]   = INITDAQ(hwname, hwnumber, constructor, [prop1, val1, etc])
%
% hwname      - the name of the device ('nidaq', 'winsound', etc)
% hwnumber    - the number of the device. 1 is correct unless multiple
%               boards are installed
% constructor - the index of the constructor to be used
% prop1/val1  - property value pairs to be set on the initialized daq
%               object
%
% daq         - the daq object
% daqname     - the field name under which the daq object is stored
%
% INITDAQ will attempt to set default properties based on the type of
% hardware being initialized. These defaults are stored in DAQ/Defaults,
% under the name of the device and its type (e.g. nidaqai). INITDAQ also
% stores the initial state of the daq object in the control structure; this
% is used to reset the DAQ to its initial state.
%
% See Also: RESETDAQ
% 
% $Id: InitDAQ.m,v 1.2 2006/01/19 03:14:55 meliza Exp $

global mpctrl

%% Set default value for adaptor number
if isempty(hwnumber)
    hwnumber    = 1;
end

%% Check that the device driver and adaptor are installed
z   = daqhwinfo;
ind = strmatch(hwname, z.InstalledAdaptors);

if length(ind) < 1
    error('METAPHYS:InitDAQ:noSuchDevice',...
        'No such device %s could be located. Check your driver and hardware',...
        hwname)
end

%% Load the constructors
z   = daqhwinfo(hwname);
% TODO: CHECK THAT MULTIPLE ADAPTORS ARE ON DIFFERENT ROWS
if size(z.ObjectConstructorName, 1) < hwnumber
    error('METAPHYS:InitDAQ:noSuchDevice',...
        'No board of type %s has the ID %d', hwname, hwnumber)
end
if size(z.ObjectConstructorName, 2) < constructor
    error('METAPHYS:InitDAQ:noSuchConstructor',...
        'Constructor index %d out of range for %s-%d',...
        constructor, hwname, hwnumber)
end

%% Call constructor.
% Note that if this subsystem already exists another
% pointer to the same object will be generated, so be careful about
% multiple invocations.
const   = z.ObjectConstructorName{hwnumber, constructor};
daq     = eval(const);

%% Generate the fieldname
daqtype = get(daq,'Type');
switch lower(daqtype)
    case 'analog input'
        dt  = 'ai';
    case 'analog output'
        dt  = 'ao';
    case 'digital io'
        dt  = 'dio';
    otherwise
        dt  = lower(daqtype);
end
daqname = sprintf('%s_%s_%s', hwname, z.InstalledBoardIds{hwnumber}, dt);

%% Attempt to set default properties
def_fn  = sprintf('%s%s', z.AdaptorName, dt);
SetObjectDefaults(daq, def_fn)
set(daq,'Name',daqname)

%% Set user-defined properties
if nargin > 3
    set(daq, varargin{:})
end
    
%% Store the object with its initial properties
props                   = get(daq);
writeableprops          = fieldnames(set(daq));
readonlyprops           = setdiff(fieldnames(props),writeableprops);
props                   = rmfield(props, readonlyprops);
daqstruct               = struct('obj',daq,...
                                 'name',daqname,...
                                 'type',daqtype,...
                                 'constructor',const,...
                                 'initial_props',props);
mpctrl.daq.(daqname)    = daqstruct;
DebugPrint('Initialized DAQ device %s.', daqname);

