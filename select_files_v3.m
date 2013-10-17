function varargout = select_files_v3(varargin)
% SELECT_FILES_V3 M-file for select_files_v3.fig
%      SELECT_FILES_V3, by itself, creates a new SELECT_FILES_V3 or raises the existing
%      singleton*.
%
%      H = SELECT_FILES_V3 returns the handle to a new SELECT_FILES_V3 or the handle to
%      the existing singleton*.
%
%      SELECT_FILES_V3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_FILES_V3.M with the given input arguments.
%
%      SELECT_FILES_V3('Property','Value',...) creates a new SELECT_FILES_V3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_files_v3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_files_v3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select_files_v3

% Last Modified by GUIDE v2.5 27-May-2010 20:49:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_files_v3_OpeningFcn, ...
                   'gui_OutputFcn',  @select_files_v3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before select_files_v3 is made visible.
function select_files_v3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select_files_v3 (see VARARGIN)

% Choose default command line output for select_files_v3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes select_files_v3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global filesN filesE filesZ N i;
i=1;
[filesZ N]=ValidateComponent('Z');
[filesE N]=ValidateComponent('Z');
[filesN N]=ValidateComponent('Z');

sacZ=rsac(filesZ(i).name);
sacN=rsac(filesN(i).name);
sacE=rsac(filesE(i).name);

h1=handles.axes1;
h2=handles.axes2;
h3=handles.axes3;

plot(h1,sacZ.t,sacZ.d);title(h1,sacZ.filename)
plot(h2,sacN.t,sacN.d);title(h2,sacN.filename)
plot(h3,sacE.t,sacE.d);title(h3,sacE.filename)



% --- Outputs from this function are returned to the command line.
function varargout = select_files_v3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1. - Back
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filesN filesE filesZ N i;
i=i-1;

h1=handles.axes1;
h2=handles.axes2;
h3=handles.axes3;

if ~exist(filesE(i).name,'file')     
    % Moves files back from Noisy directory    
    movefile(['Noisy/' filesE(i).name],'.');  
end
if ~exist(filesN(i).name,'file')     
    % Moves files back from Noisy directory    
    movefile(['Noisy/' filesN(i).name],'.');  
end
if ~exist(filesZ(i).name,'file')     
    % Moves files back from Noisy directory    
    movefile(['Noisy/' filesZ(i).name],'.');  
end
sacZ=rsac(filesZ(i).name);
sacN=rsac(filesN(i).name);
sacE=rsac(filesE(i).name);

plot(h1,sacZ.t,sacZ.d);title(h1,sacZ.filename)
plot(h2,sacN.t,sacN.d);title(h2,sacN.filename)
plot(h3,sacE.t,sacE.d);title(h3,sacE.filename)

% --- Executes on button press in pushbutton2. - KEEP
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filesN filesE filesZ N i;
i=i+1;

if i>N
     close all;
     return;
end
 
h1=handles.axes1;
h2=handles.axes2;
h3=handles.axes3;

sacZ=rsac(filesZ(i).name);
sacN=rsac(filesN(i).name);
sacE=rsac(filesE(i).name);

plot(h1,sacZ.t,sacZ.d);title(h1,sacZ.filename)
plot(h2,sacN.t,sacN.d);title(h2,sacN.filename)
plot(h3,sacE.t,sacE.d);title(h3,sacE.filename)

% --- Executes on button press in pushbutton3. - NOISY
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filesN filesE filesZ N i;
if ~exist('Noisy','dir')
    mkdir('Noisy');
end

 movefile(filesN(i).name,'Noisy');
 %movefile(filesE(i).name,'Noisy');
 %movefile(filesZ(i).name,'Noisy');

 i=i+1;
 
 if i>N
     close all;
     return;
 end
 
h1=handles.axes1;
h2=handles.axes2;
h3=handles.axes3;

sacZ=rsac(filesZ(i).name);
sacN=rsac(filesN(i).name);
sacE=rsac(filesE(i).name);

plot(h1,sacZ.t,sacZ.d);title(h1,sacZ.filename)
plot(h2,sacN.t,sacN.d);title(h2,sacN.filename)
plot(h3,sacE.t,sacE.d);title(h3,sacE.filename)
 

% --- Executes on button press in pushbutton4. -EXIT
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all
return
