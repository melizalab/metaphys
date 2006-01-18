function [] = DataHandler(obj, event)
%
% DATAHANDLER Handles dispersing data to subscribers
%
% DATAHANDLER is called by the DAQ driver when there is data to be
% processed.  It runs through the list of subscribers, figures out who
% wants what data, and passes data packets to the subscribing functions.
%
% $Id: DataHandler.m,v 1.1 2006/01/18 19:01:02 meliza Exp $

global mpctrl


% get the subscribers (direct through mpctrl for speed)
if isstruct(mpctrl.subscriber)
    % retrieve the data
    [data, time, abstime, events]   = getdata(obj);
    daqname     = obj.Name;

    clients = fieldnames(mpctrl.subscriber);
    for i = 1:length(clients);
        % start with the default packet
        packet  = packet_struct;

        client              = mpctrl.subscriber.(clients{i});
        packet.name         = client.name;
        packet.instrument   = client.instrument;
        [ind chan]          = GetChannelIndices(client.instrument, daqname);
        if isempty(ind)
            packet.message = 'No data from subscribed channels';
        else
            packet.channels = CellWrap(chan);
            packet.data     = data(:,ind);
            packet.time     = time;
            packet.timestamp= datenum(abstime);
            % TODO: parse the event
        end
        % send the packet
        try
            feval(client.fhandle, packet, client.fargs{:})
        catch
            le  = lasterror;
            DebugPrint('Error calling subscriber %s function:\n%s',...
                        client.name, le.message)
        end
    end
else
    DebugPrint('Data received; no subscriptions.')
    daqcallback(obj, event)
end