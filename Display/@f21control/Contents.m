% @F21CONTROL
%
% The F21CONTROL class is used to control a remote computer running f21mv
% or f21mvx. These are stimulus display programs developed by Yuxi Fu. This
% class allows METAPHYS to communicate with this program for movie playback
% and tuning curve measurement.
%
% Construct an F21 controller with the constructore F21CONTROL. The
% low-level commands SENDCOMMAND and SENDREQUEST are used to communicate
% with the remote program. Use GET to retrieve properties from the F21
% program; SETMOVIELIST to setup movies for playback and PREPAREMOVIE and
% STARTMOVIE to start playback. See help files for individual methods for
% more details.
%
% Files
%   delete         - closes and deletes an F21CONTROL object
%   f21control     - Constructs a F21CONTROL object (controller for another
%   get            - Gets F21control object properties
%   getmoviefiles  - Returns a list of movie files available to f21
%   getmovielist   - Gets the movie list for an f21 object
%   getobjectcount - Retrieves the # of display objects. F21mvx only.
%   preparemovie   - Prepares F21 for movie playback; F21 loads all chosen movie
%   preparetuning  - Prepares the remote f21 for a tuning test. Returns the
%   sendcommand    - Sends a command to the F21 connection
%   sendrequest    - Sends a command to the F21 connection and returns a response.
%   set            - Sets F21CONTROL object properties
%   setmovielist   - Sets the movie list for an f21 object
%   startmovie     - Starts movie playback
%   starttuning    - Begins the tuning test. PREPARETUNING must be called first.
%   stopmovie      - Stops movie playback
%   display        - Display method for F21CONTROL object.
%   isvalid        - Returns boolean indicating whether the object has a valid
%   char           - Returns the character array representation of f21control object
%   getmovietime   - Returns the amount of time (in ms) it will take to play the
%   isempty        - Returns true if the f21control object is not complete
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
