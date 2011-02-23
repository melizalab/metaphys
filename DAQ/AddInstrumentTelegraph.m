function [] = AddInstrumentTelegraph(instrument, telegraph, varargin)
%
% ADDINSTRUMENTTELEGRAPH Defines a telegraph channel for an instrument.
%
% Usage:
%
% [] = ADDINSTRUMENTTELEGRAPH('instrument', 'telegraph', input, @checkfn,
% @updatefn, [args]): initializes the telegraph with the input object and the
% associated functions. The most general usage. ARGS are passed to the
% checkfn and updatefn when they are called.
%
% [] = ADDINSTRUMENTTELEGRAPH('instrument', 'telegraph', "200x", 'daqname',  
% modechannel, gainchannel, {ampchannels}): initializes a standard 200A/B 
% telegraph configuration. NOTE: The user must supply two *hardware* input 
% channels to use for the mode and gain signals, and *named* channels 
% for the amplifier input/output.
%
% [] = ADDINSTRUMENTTELEGRAPH('instrument', 'telegraph', "1x", 'daqname', 
% gainchannel, {ampchannels}). The 1-X series of axon amplifiers doesn't 
% support a mode telegraph, so the best configuration is to assign two
% instrumentoutputs to the same hardware channel. These are *named*,
% whereas the telegraph channel is *numerical* (hardware).
%
% [] = ADDINSTRUMENTTELEGRAPH(instrument, telegraph, '700x', input1,
% input2). Not yet supported.
%
% AMPCHANNEL can be a single name or a cell array of names.
% ("200x" and "1x" are literal strings)
%
% See also: UPDATETELEGRAPH, GETTELEGRAPH, DELETEINSTRUMENTTELEGRAPH
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

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
            updfn       = @UpdScaledChannel;
        case '1x'
            daqname     = varargin{2};
            gainchan    = varargin{3};
            output      = {varargin{4:end}};
            object      = initchannel(instrument, daqname,...
                'gaintelegraph',...
                gainchan);
            checkfn     = @Check1XTelegraph;
            updfn       = @UpdScaledChannel;
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
