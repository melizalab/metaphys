% UTILITY
%
% Utility functions that integrate MATLAB's figure and uiobjects into the
% METAPHYS control structure.
%
% * Params and UIParams:
%
%   It is often the case that you will want certain values to be available
%   to a number of modules. These values are stored in the control
%   structure, and are made easily accessible as Params and UIParams. The
%   difference between Params and UIParams is that Params are invisible to
%   the end user and are only modified through the associated functions,
%   whereas UIParams are associated with MATLAB uicontrols, and can be
%   modified by the user through the GUI. The functions associated with
%   Params are INITPARAM, GETPARAM, and SETPARAM. The functions associated
%   with UIParams are INITUICONTROL, INITUIOBJECT, GETUIHANDLE, GETUIPARAM,
%   and SETUIPARAM. Their use is fairly self-explanatory and they have been
%   documented extensively.
% 
%   If a number of parameters are associated with one another, then the
%   PARAMFIGURE can be used to display and manipulate their values. This is
%   done by creating a structure that contains the parameter names, types,
%   and default values, and passing it to PARAMFIGURE, which creates a
%   figure that contains all those parameters, and futhermore allows the
%   end user to store the parameter set as a matfile.
%
% Files
%   ClearDefaults       - Clear default values for an object
%   DebugPrint          - Outputs debugging messages. 
%   DebugSetOutput      - Sets the current debug mode.
%   DeleteModule        - Removes a module from the control structure and deletes
%   DestroyControl      - Performs a complete cleanup of the METAPHYS system. 
%   FindFigure          - Finds the figure window with a given tag.  
%   GetDefaults         - Retrieves default values for an object.
%   GetModule           - Returns the module substructure from the control structure. 
%   GetParam            - Accesses the contents of a non-GUI parameter. 
%   GetParamStructValue - Retrieves the value from a parameter structure. 
%   GetSelected         - Returns the string selected in a list or popupmenu
%   GetUIHandle         - Returns the handle(s) of UI objects stored in the control
%   GetUIObjectSize     - Computes the size of an object in a given set of units.
%   GetUIParam          - Retrieve the value of a parameter stored in a MATLAB GUI
%   InitControl         - Initializes the control structure (mpctrl).
%   InitModule          - Initializes a module in the control structure. 
%   InitParam           - Initializes a parameter in the control structure. 
%   InitUIControl       - Creates an uicontrol and stores the handle in the 
%   InitUIObject        - Creates a GUI object and adds its handle to the control
%   InitUIParam         - Stores a handle in the control structure, which can be
%   LoadControl         - Loads a file containing information to go into the control
%   OpenFigure          - Opens a blank figure window, or if a figure with that handle 
%   OpenGuideFigure     - Opens a figure window using a GUIDE-generated .fig
%   ParamFigure         - Opens or updates a parameter figure window. 
%   ResizeFigure        - Resizes a figure window while keeping it in place.
%   SaveControl         - Writes fields from the control structure to a matfile for
%   SetDefaults         - Set default values for an object.
%   SetObjectDefaults   - Sets properties on an object (an uicontrol or a matlab
%   SetParam            - Sets the value of a module parameter. 
%   SetParamStructValue - Sets the value field in a parameter structure based
%   SetUIParam          - Sets a parameter of an object stored in the control
%   WriteStructure      - Writes a structure to a mat file. 
%   CellWrap            - Ensures that a variable is either a cell array or is wrapped in
%   DeleteUIParam       - Removes an uiparam from control and deletes its handle
%   GetFields           - Returns one or more fields from a structure in a new structure
%   StructFlatten       - attempts to remove the fieldnames from a structure.
%   Cell2Num            - Casts as many elements to numbers in a cell array as possible.
%   NextDataFile        - Returns the next directory/filename for data storage.
%   Packet2R0           - Converts an array of packet structures into an array of r0
%   Packet2R1           - Converts an array of packet structures into an array of r1
%   SplitPacket         - Converts multichannel packet(s) into multiple single-channel
%   StrTokenize         - Completely de-tokenizes a string
%   StructConstruct     - Generic constructor for predefined structures.
%   GetGlobal           - Returns the value of a global variable in the control
%   ListRearranger      - A callback handler used for moving items around in a
%   SetGlobal           - Sets a global variable in the control structure
%   uisetdatadir        - A dialog window that fetches a directory; analogous to UIGETFILE.
%   WaveformEditor      - Dialog for specifying waveforms for output to instruments
%   multilcm            - returns the least common multiple of an array of positive
%   shuffledsequence    - Generates a shuffled sequence
%   setselected         - Sets the selected item in a list or popupmenu
%   wmean               - Weighted average or mean value.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%
