function varargout = select_files_1c(varargin)
% SELECT_FILES_1C M-file for select_files_1c.fig
%      SELECT_FILES_1C, by itself, creates a new SELECT_FILES_1C or raises the existing
%      singleton*.
%
%      H = SELECT_FILES_1C returns the handle to a new SELECT_FILES_1C or the handle to
%      the existing singleton*.
%
%      SELECT_FILES_1C('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_FILES_1C.M with the given input arguments.
%
%      SELECT_FILES_1C('Property','Value',...) creates a new SELECT_FILES_1C or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_files_1c_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_files_1c_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select_files_1c

% Last Modified by GUIDE v2.5 25-Oct-2010 15:26:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_files_1c_OpeningFcn, ...
                   'gui_OutputFcn',  @select_files_1c_OutputFcn, ...
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


% --- Executes just before select_files_1c is made visible.
function select_files_1c_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select_files_1c (see VARARGIN)

% Choose default command line output for select_files_1c
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes select_files_1c wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global filesZ N i;
i=1;
[filesZ N]=ValidateComponent('Z');

sacZ=rsac(filesZ(i).name);

h1=handles.axes1;

plot(h1,sacZ.t,sacZ.d,'k');
disp(['Distance = ' num2str(sacZ.dist) ' km.'])
r=sqrt(sacZ.dist^2+sacZ.evdp^2);
if sacZ.a ~= -12345
    draw_vert(sacZ.a)
end
if sacZ.picks(1) ~= -12345
    draw_vert(sacZ.picks(1),'b')
else
    draw_vert(r/3.5,'g');
end
title(h1,sacZ.filename)
setw

% --- Outputs from this function are returned to the command line.
function varargout = select_files_1c_OutputFcn(hObject, eventdata, handles) 
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
global filesZ N i;
i=i-1;

h1=handles.axes1;

if ~exist(filesZ(i).name,'file')     
    % Moves files back from Noisy directory    
    movefile(['Noisy/' filesZ(i).name],'.');  
end
sacZ=rsac(filesZ(i).name);
plot(h1,sacZ.t,sacZ.d,'k');
disp(['Distance = ' num2str(sacZ.dist) ' km.'])
title(h1,sacZ.filename)
if sacZ.a ~= -12345
    draw_vert(sacZ.a)
end
if sacZ.picks(1) ~= -12345
    draw_vert(sacZ.picks(1),'b')
else
    r=sqrt(sacZ.dist^2+sacZ.evdp^2);
    draw_vert(r/3.5,'g')
end

% --- Executes on button press in pushbutton2. - Keep
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

sacZ=rsac(filesZ(i).name);
plot(h1,sacZ.t,sacZ.d,'k');
disp(['Distance = ' num2str(sacZ.dist) ' km.'])
title(h1,sacZ.filename)
if sacZ.a ~= -12345
    draw_vert(sacZ.a)
end
if sacZ.picks(1) ~= -12345
    draw_vert(sacZ.picks(1),'b')
else
    r=sqrt(sacZ.dist^2+sacZ.evdp^2);
    draw_vert(r/3.5,'g')
end

% --- Executes on button press in pushbutton3. Noisy
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filesZ N i;
if ~exist('Noisy','dir')
    mkdir('Noisy');
end

 movefile(filesZ(i).name,'Noisy');

 i=i+1;
 
 if i>N
     close all;
     return;
 end
 
h1=handles.axes1;

sacZ=rsac(filesZ(i).name);
plot(h1,sacZ.t,sacZ.d,'k');
disp(['Distance = ' num2str(sacZ.dist) ' km.'])
title(h1,sacZ.filename)
if sacZ.a ~= -12345
    draw_vert(sacZ.a)
end
if sacZ.picks(1) ~= -12345
    draw_vert(sacZ.picks(1),'b')
else
    r=sqrt(sacZ.dist^2+sacZ.evdp^2);
    draw_vert(r/3.5,'g')
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all
return
