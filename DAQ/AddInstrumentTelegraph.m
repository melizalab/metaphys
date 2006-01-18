function [] = AddInstrumentTelegraph(instrument, telegraph, varargin)
%
% ADDINSTRUMENTTELEGRAPH Defines a telegraph channel for an instrument.
%
% Telegraphs are a special type of instrument output used to communicate
% information about the internal state of the instrument. With most
% instrument hardware (e.g. the AxoClamp 200B, etc), these are analog
% outputs whose voltage is associated with a particular mode or gain
% setting on the instrument.  On newer instrumentation, telegraph
% information is conveyed digitally, through a (traditional) serial port or
% a USB connection.
%
% Unlike normal instrument channels, the value of a telegraph controls the
% way acquisition proceeds. The gain and units of the instrument's output
% will change depending on these values. Thus, telegraphs need to be
% checked before starting acquisition, and, if the user is acquiring data
% continuously (e.g., during a seal test), on a fairly regular basis so
% that the display and any calculated values are correct.
%
% Needless to say, the number of ways in which telegraphs are implemented
% leads to complications in the software. Voltage telegraphs are the
% easiest to use, since calls to getsample() will retrieve the current
% values regardless of the state of the analoginput object.  For serial
% port telegraphs (Multiclamp 700A and 700B), the only implementation that
% has a chance of working is to use the driver provided by Axon that
% interfaces with the MultiClampCommander. NOT YET IMPLMENTED. 
%
% Telegraphing is implemented as follows:
% 1) a telegraph structure is added to the mpctrl.instrument tree, which
% contains: 
%   - a pointer to the relevant input (aichannel or otherwise)
%   - a "check value" function handle that retrieves the values from the
%     input
%   - a function handle that updates the instrument configuration
%
% 2) a function, UPDATETELEGRAPH, that calls the two function handles
% associated with the named telegraphs.
%
% 3) a collection of functions for retrieving data from various instruments
%    (stored in DAQ/Telegraph)
% 4) a standardized gain/mode function that can be associated with multiple
%    channels (DAQ/Telegraph/UpdScaledOutput)
%
% This structure separates getting the telegraph data from updating the
% instrument, and allows for a significant amount of built-in flexibility
% as well as the ability to execute any arbitrary function in consequence
% of the telegraph update.
%
% Usage:
%
% [] = ADDINSTRUMENTTELEGRAPH(instrument, telegraph, input, checkfn,
% updatefn, [args]): initializes the telegraph with the input object and the
% associated functions. The most general usage. ARGS are passed to the
% checkfn and updatefn when they are called.
%
% [] = ADDINSTRUMENTTELEGRAPH(instrument, telegraph, '200x', daqname,  
% modechannel, gainchannel, ampchannel): initializes a standard 200A/B 
% telegraph configuration. NOTE: The user must supply two *hardware* input 
% channels to use for the mode and gain signals, and one *named* channel 
% for the amplifier output.
%
% [] = ADDINSTRUMENTTELEGRAPH(instrument, telegraph, '1x', daqname, 
% gainchannel, ampchannels). The 1-X series of axon amplifiers doesn't 
% support a mode telegraph, so the best configuration is to assign two
% instrumentoutputs to the same hardware channel. These are *named*,
% whereas the telegraph channel is *numerical* (hardware).
%
% [] = ADDINSTRUMENTTELEGRAPH(instrument, telegraph, '700x', input1,
% input2). Not yet supported.
%
% AMPCHANNEL can be a single name or a cell array of names.
%
% See Also: UPDATETELEGRAPH, GETTELEGRAPH, DELETEINSTRUMENTTELEGRAPH
%
% $Id: AddInstrumentTelegraph.m,v 1.3 2006/01/19 03:14:52 meliza Exp $

% This function is just a wrapper for private/AddTelegraph. If you want to
% add another "standard" telegraph, this is where to set up how the
% arguments are parsed.

% Parse the arguments
if isobject(varargin{1})
    % general case, pass directly to AddTelegraph
    AddTelegraph(instrument, telegraph, varargin{:});
else
    inst_type = lower(varargin{1});
    switch inst_type
        case '200x'
            daqname     = varargin{2};
            modechan    = varargin{3};
            gainchan    = varargin{4};
            output      = {varargin{5:end}};
            gainobj     = initchannel(instrument, daqname,...
                'gaintelegraph',...
                gainchan);
            modeobj     = initchannel(instrument, daqname,...
                'modetelegraph',...
                modechan);
            object      = [gainobj modeobj];
            checkfn     = @Check200XTelegraph;
            updfn       = @UpdScaledOutput;
        case '1x'
            daqname     = varargin{2};
            gainchan    = varargin{3};
            output      = {varargin{4:end}};
            object      = initchannel(instrument, daqname,...
                'gaintelegraph',...
                gainchan);
            checkfn     = @Check1XTelegraph;
            updfn       = @UpdScaledOutput;
        case '700x'
            error('METAPHYS:notSupported',...
                'No support for 700x series telegraphs yet...')
        otherwise
            error('METAPHYS:notSupported',...
                'No support for %s telegraphs.', varargin{1})
    end
    AddTelegraph(instrument, telegraph, inst_type, object,...
        checkfn, updfn, output)
end

function c  = initchannel(instrument, daqname, channelname, hwchannel)
% telegraph channels need to use the full input range
% they are NOT stored in the usual channel structure, so we don't use
% ADDINSTRUMENTOUTPUT
daq = GetDAQ(daqname);
c   = addchannel(daq, hwchannel, channelname);
set(c,'InputRange',[-10 10],'SensorRange',[-10 10],'UnitsRange',[-10 10],...
    'Units', 'V');
