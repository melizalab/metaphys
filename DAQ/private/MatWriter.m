function [] = MatWriter(packet, directory)
%
% MATWRITER Collects data packets and writes them to disk as a matfile when
% acquisition is over
%
% MATWRITER is an alternative to using the builtin data logging functions
% of the DAQ toolkit. MATWRITER subscribes to DATAHANDLER and collects
% packets over the course of acquisition. At the end of acquisition it
% sorts the packets according to instrument and generates r0 or r1 files
% which it writes to disk.
%
% MATWRITER knows it needs to write to disk when (a) it receives a packet
% with an error in it or (b) it is invoked with a new file name, or (c) it
% is invoked as follows:
%
% MATWRITER('flush')
%
% $Id: MatWriter.m,v 1.1 2006/01/20 22:02:32 meliza Exp $

persistent mw_data datafile

% determine the packet event
if ischar(packet) 
    flush_data(mw_data, datafile);
    mw_data = [];
elseif ~strcmpi(directory, datafile)
    flush_data(mw_data, datafile);
    mw_data     = newdata(mw_data, packet);
    datafile    = directory;
else
    switch lower(packet.message.Type)
        case {'runtimeerror','datamissed'}
            if ~isempty(packet.data)
                mw_data = newdata(mw_data, packet);
            end
           
            flush_data(mw_data, directory);
            mw_data = [];

        case {'samplesacquired','stop'}
            % packets are just catted together during acquisition
            mw_data     = newdata(mw_data, packet);
            datafile    = directory;
        otherwise
            DebugPrint('Unrecognized event type %s', packet.message.type);
    end
end

function [] = flush_data(mw_data, file)
if ~isempty(mw_data)
    instr = unique({mw_data.instrument});
    for i = 1:size(instr,2)
        ind_instr   = strmatch(instr{i}, {mw_data.instrument}, 'exact');
        packets     = mw_data(ind_instr);
        % PACKET2R0 will fail if packets are of uneven length
        try
            packets     = Packet2R0(packets);
            filename    = sprintf('%s.%s.r0', file, instr{i});
            save(filename, 'packets', '-mat')
            DebugPrint('Wrote packet data to %s.', filename);
        catch
            try
                packets     = Packet2R1(packets);
                filename    = sprintf('%s.%s.r1', file, instr{i});
                save(filename, 'packets', '-mat')
                DebugPrint('Wrote packet data to %s.', filename);
            catch
                % Now we're in trouble. Save the data to disk as-is
                DebugPrint('Unable to write packet data to R0 or R1 file.')
                filename    = sprintf('%s.%s.mat', file, instr{i});
                save(filename, 'packets', '-mat')
                DebugPrint('Wrote packet data to %s.', filename);
            end
        end
    end
end


function out    = newdata(old, new)
out = cat(1,old, new);
