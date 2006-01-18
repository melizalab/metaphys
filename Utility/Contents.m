% UTILITY
%
% Utility functions that integrate MATLAB's figure and uiobjects into the
% METAPHYS control structure.
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
%
% $Id: Contents.m,v 1.2 2006/01/19 03:15:04 meliza Exp $