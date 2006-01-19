function [results] = UpdateTelegraph(instrument, telegraph)
%
% UPDATETELEGRAPH Reads values from instrument telegraphs and updates the
% instrument control structures accordingly (e.g. by changing gain or
% units). See ADDINSTRUMENTTELEGRAPH for more details on how this works.
%
% UPDATETELEGRAPH(instrument, telegraph) updates the telegraph specifically
% referred to by instrument and telegraph name.
%
% UPDATETELEGRAPH(instrument) updates all the telegraphs on a given
% instrument.
%
% UPDATETELEGRAPH() updates all telegraphs in the control structure. This
% requires cycling through a lot of fieldnames, and so should be used
% sparingly during acquisition.
%
% UPDATETELEGRAPH calls the checkfn and updfn functions for each telegraph
% with the following signatures:
%       results   = checkfn(instrument, object, fnargs...)
%       updfn(instrument, results, fnargs...)
%
% $Id: UpdateTelegraph.m,v 1.2 2006/01/20 00:04:40 meliza Exp $
global mpctrl

results = [];
if nargin > 1
    if ~isfield(mpctrl.instrument, instrument)
        error('METAPHYS:daq:noSuchInstrument',...
            'No such instrument %s has been defined.', instrument)
    end
end
if nargin > 2
    if ~isfield(mpctrl.instrument.(instrument), telegraph)
        error('METAPHYS:daq:noTelegraphsDefined',...
            'No telegraphs have been defined on instrument %s.',...
            instrument)
    end
end

switch nargin
    case 2
        tele_struct = mpctrl.instrument.(instrument).telegraph.(telegraph);
        results.(instrument) = myupdatetele(instrument, tele_struct)
    case 1
        inst_struct = mpctrl.instrument.(instrument);
        results.(instrument) = updateinstrumenttelegraphs(instrument, inst_struct);
    case 0
        instruments = GetInstrumentNames();
        warning('off','METAPHYS:daq:noTelegraphsDefined');
        for i = 1:length(instruments)
            r   = updateinstrumenttelegraphs(instruments{i},...
                        mpctrl.instrument.(instruments{i}));
            if ~isempty(r)
                results.(instruments{i}) = r;
            end
        end
        warning('on','METAPHYS:daq:noTelegraphsDefined');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [results] = updateinstrumenttelegraphs(instrument, inst_struct)
% we just throw a warning if there aren't any telegraphs
results = [];
if isempty(inst_struct.telegraph)
    warning('METAPHYS:daq:noTelegraphsDefined',...
        'No telegraphs have been defined on this instrument.')
else
    telenames   = fieldnames(inst_struct.telegraph);
    for i = 1:length(telenames)
        results = cat(1, results,...
            myupdatetele(instrument, inst_struct.telegraph.(telenames{i})));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [results] = myupdatetele(instrument, tele_struct)
% Actually updates a single telegraph on a single instrument.

results = feval(tele_struct.checkfn, instrument,...
    tele_struct.obj, tele_struct.output);
feval(tele_struct.updfn, instrument, results, tele_struct.output);


