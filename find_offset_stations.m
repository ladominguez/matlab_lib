function varargout = find_offset_stations(varargin)
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

% Last Modified by GUIDE v2.5 05-Aug-2011 15:04:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @find_offset_stations_OpeningFcn, ...
                   'gui_OutputFcn',  @find_offset_stations_OutputFcn, ...
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
clc
% End initialization code - DO NOT EDIT


% --- Executes just before find_offset_stations is made visible.
function find_offset_stations_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to find_offset_stations (see VARARGIN)

% Choose default command line output for find_offset_stations
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global files N k
files = dir('*.sac');
N     = numel(files);
h1    = handles.axes1;
k     = 1;
a     = rsac(files(k).name);
t0    = a.dist/3.7;
plot(h1,a.t,a.d);title(h1,[a.filename ' - distance = ' num2str(a.dist) 'km.'])
draw_vert(t0);
xlim([0 50])

% UIWAIT makes find_offset_stations wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = find_offset_stations_OutputFcn(hObject, eventdata, handles) 
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
global files N k;
k=k-1;

h1=handles.axes1;

if ~exist(files(k).name,'file')     
    % Moves files back from Noisy directory    
    movefile(['Offset/' files(k).name],'.');  
end
a=rsac(files(k).name);

plot(h1,a.t,a.d);title(h1,a.filename);title(h1,[a.filename ' - distance = ' num2str(a.dist) 'km.'])

draw_vert(a.dist/3.7);
xlim([0 50])

% --- Executes on button press in pushbutton2. - Offset 
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global files N k;

if ~exist('Offset','dir')
    mkdir('Offset');
end

 movefile(files(k).name,'Offset');

 k=k+1;
 
 if k>N
     close all;
     return;
 end
 
h1=handles.axes1;

a=rsac(files(k).name);

plot(h1,a.t,a.d);title(h1,[a.filename ' - distance = ' num2str(a.dist) 'km.'])
draw_vert(a.dist/3.7);
xlim([0 50])
% --- Executes on button press in pushbutton3. - Keep
function pushbutton3_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global files N k;
k=k+1;

if k>N
     close all;
     return;
end
 
h1=handles.axes1;

a=rsac(files(k).name);

plot(h1,a.t,a.d);
title(h1,[a.filename ' - distance = ' num2str(a.dist) 'km.'])
draw_vert(a.dist/3.7);
xlim([0 50])
% --- Executes on button press in pushbutton4. _ Exit
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all
return
