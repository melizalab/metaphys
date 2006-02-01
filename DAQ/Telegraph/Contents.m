% TELEGRAPH
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
% Files
%   Check1XTelegraph     - Checks the telegraph values on a 1-series Axon
%   Check200XTelegraph   - Checks the telegraph values on a 200-series Axon
%   CheckAnalogTelegraph - Checks the voltage values of one or several analog
%   UpdScaledOutput      - Updates a scaled output channel based
%   CalcGain             - Omnibus function for determining the input and output gain
%   CalcMode             - Omnibus function for determining the mode from telegraph
%   CalcUnits            - Omnibus function for determining the input and output units
%   UpdScaledChannel     - Updates one or more channels on an amplifier based
%   UpdScaledInput       - Updates a scaled input channel based on the mode and
%
% $Id: Contents.m,v 1.5 2006/02/01 19:57:49 meliza Exp $
