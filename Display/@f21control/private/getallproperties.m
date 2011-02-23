function s = getallproperties(obj)
%
% GETALLPROPERTIES Returns all properties from the f21 object as a
% structure.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% there are two commands that will retrieve all stimulus properties

SYSPARAMS = {'frame_rate_factor', 'frames', 'refresh_rate',...
    'time_before_trigger', 'mmrf_num_in_test_list', 'mmrf_interval',...
    'mmrf_single_time', 'project_name', 'video_mode'};

sysparams = sendrequest(obj, 'get_val', 'system_parameters');
sysparams = Cell2Num(StrTokenize(sysparams));
stiparams = sendrequest(obj, 'sti_get_parameters');
stiparams = StrTokenize(stiparams);

nparams   = str2double(stiparams{2});
stiparams = reshape(stiparams(3:end), 2, nparams);
STIPARAMS = stiparams(1,:);
stiparams = Cell2Num(stiparams(2,:));

s   = cell2struct({sysparams{2:end}, stiparams{:}},...
                  {SYSPARAMS{:}, STIPARAMS{:}},2);

mvlists     = strmatch('MovieList', STIPARAMS);
for i = 1:length(mvlists)
    fn      = STIPARAMS{mvlists(i)};
    movies  = s.(fn)(2:end);
    if isempty(movies)
        movies  = {};
    else
        movies  = StrTokenize(s.(fn)(2:end), ' ');
    end
    s.(fn)  = movies;
end