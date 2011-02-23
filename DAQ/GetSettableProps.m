function props  = GetSettableProps(daq)
%
% GETSETTABLEPROPS   Retrieves the property names and values that can be set
% on a daq object
%
% GETSETTABLEPROPS(daq) returns a structure that contains the properties of
% a daq device that are not read-only. This function should be called on
% any newly created daq device so that RESETDAQ works. This includes DAQ
% devices loaded from disk.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ~isempty(daq) && isvalid(daq)
    props                   = get(daq);
    writeableprops          = fieldnames(set(daq));
    readonlyprops           = setdiff(fieldnames(props),writeableprops);
    props                   = rmfield(props, readonlyprops);
else
    props               = struct([]);
end
