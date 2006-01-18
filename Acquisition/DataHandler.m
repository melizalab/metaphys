function [] = DataHandler(obj, event)
%
% DATAHANDLER Handles dispersing data to subscribers
%
% DATAHANDLER is called by the DAQ driver when there is data to be
% processed.  It runs through the list of subscribers, figures out who
% wants what data, and passes data packets to the subscribing functions.
%
% $Id: DataHandler.m,v 1.2 2006/01/19 03:14:51 meliza Exp $

global mpctrl


% get the subscribers (direct through mpctrl for speed)
if isstruct(mpctrl.subscriber)
    % retrieve the data, if there is any. This behavior is going to change
    % according to the type of event
    switch event.Type
        case 'SamplesAcquired'
            avail            = get(obj,'SamplesAcquiredFcnCount');
            [data, time, abstime]   = getdata(obj, avail);
        otherwise
            avail            = get(obj,'SamplesAvailable');
            if avail > 0
                [data, time, abstime]   = getdata(obj, avail);
            else
                [data, time, abstime]   = deal([]);
            end
    end
    daqname     = obj.Name;

    clients = fieldnames(mpctrl.subscriber);
    for i = 1:length(clients);
        % start with the default packet
        packet  = packet_struct;

        client              = mpctrl.subscriber.(clients{i});
        packet.name         = client.name;
        packet.instrument   = client.instrument;
        packet.message      = event;
        % if the instrument or data is empty we send an empty packet
        if ~isempty(client.instrument) && ~isempty(data)
            [ind chan]          = GetChannelIndices(client.instrument, daqname);
            if ~isempty(ind)
                packet.channels = CellWrap(chan);
                packet.units    = CellWrap(obj.Channel(ind).Units);
                packet.data     = data(:,ind);
                packet.time     = (time - time(1)) * 1000;  % convert to ms
                packet.timestamp= datenum(abstime);
            end
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