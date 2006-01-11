function [chan cname]   = GetInstrumentChannel(instrument, cname)
%
% GETINSTRUMENTCHANNEL Returns the channel object associated with an
% instrument channel. 
%
% If the instrument or channel have not been defined, an error is thrown.
%
% chan = GETINSTRUMENTCHANNEL(instrument, channel)
%
% CHANNEL can be a cell array, in which case multiple channels will be
% retrieved as an array of objects.
%
% chan = GETINSTRUMENTCHANNEL(instrument) - returns all channels
%
%
% $Id: GetInstrumentChannel.m,v 1.3 2006/01/11 23:04:01 meliza Exp $

instr   = GetInstrument(instrument);

switch nargin
    case 1
        if isstruct(instr.channels)
            cname   = fieldnames(instr.channels);
            chan    = getchannels(instr,cname);
        else
            cname   = [];
            chan    = [];
        end
    otherwise
        if iscell(cname)
            chan    = getchannels(instr,cname);
        else
            chan    = getchannels(instr,{cname});
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function chan = getchannels(instr, cname)
% building this array is a PAIN IN THE F-ING ASS because daqchild/subsref
% is kind of broken, and cat has problems with objects, so we have to
% generate the assignment string and eval it.
refstr  = 'instr.channels.(''%s'')';
arrstr  = '';
for i = 1:length(cname)
    checkchannel(instr, cname{i})
    arrstr  = sprintf('%s %s', arrstr,...
        sprintf(refstr, cname{i}));
end
sf      = sprintf('[%s]', arrstr);
chan    = eval(sf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = checkchannel(instr, cname)
% checks if the channel exists

if ~isfield(instr.channels, cname)
    error('METAPHYS:daq:noSuchChannel',...
        'No such channel %s has been defined for instrument %s.',...
        cname, instr)
end 
