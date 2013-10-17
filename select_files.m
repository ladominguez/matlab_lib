function varargout = select_files(varargin)
% SELECT_FILES M-file for select_files.fig
%      SELECT_FILES, by itself, creates a new SELECT_FILES or raises the existing
%      singleton*.
%
%      H = SELECT_FILES returns the handle to a new SELECT_FILES or the handle to
%      the existing singleton*.
%
%      SELECT_FILES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_FILES.M with the given input arguments.
%
%      SELECT_FILES('Property','Value',...) creates a new SELECT_FILES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_files_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_files_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select_files

% Last Modified by GUIDE v2.5 22-Apr-2008 19:41:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_files_OpeningFcn, ...
                   'gui_OutputFcn',  @select_files_OutputFcn, ...
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


% --- Executes just before select_files is made visible.
function select_files_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select_files (see VARARGIN)

% Choose default command line output for select_files
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes select_files wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clc
global files_z files_e files_n;
FullName=fullfile(pwd,'*HHZ.sac');
files_z=dir(FullName); 
FullName=fullfile(pwd,'*HHE.sac');
files_e=dir(FullName);
FullName=fullfile(pwd,'*HHN.sac');
files_n=dir(FullName);
global i max;
i=1;
max=length(files_z);
full_name=fullfile(pwd,files_z(i).name); 
[tz ys_z p]=readsac(full_name);

full_name=fullfile(pwd,files_e(i).name); 
[te ys_e p]=readsac(full_name);

full_name=fullfile(pwd,files_n(i).name); 
[tn ys_n p]=readsac(full_name);

h1=handles.axes1;
h2=handles.axes2;
h3=handles.axes3;

plot(h1,tz,ys_z); ylabel('Vertical');
plot(h2,te,ys_e); ylabel('East');
plot(h3,tn,ys_n); ylabel('North');

% --- Outputs from this function are returned to the command line.
function varargout = select_files_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i max;
global files_n files_z files_e;
%files_n;
 i=i+1;
 
 if i>max
     close all;
     return;
 end
 
 full_name=fullfile(pwd,files_z(i).name);
 ys_z=rsac(full_name);
 full_name=fullfile(pwd,files_e(i).name);
 ys_e=rsac(full_name);
 full_name=fullfile(pwd,files_n(i).name); 
 ys_n=rsac(full_name);
 
 h1=handles.axes1;
 h2=handles.axes2;
 h3=handles.axes3;
 
 [f_z,X_z]=FFourier(ys_z.d,1./ys_z.dt);
% Commented lines by DRLA 
  semilogx(h1,f_z,2*abs(X_z)); ylabel('FFT');
  plot(h2,ys_z.t,ys_z.d); ylabel('Vertical');
  plot(h3,ys_n.t,ys_n.d,ys_e.t,ys_e.d); ylabel('Horizontal');



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global i max;
global files_n files_z files_e;

if ~exist('Noisy','dir')
    mkdir('Noisy');
end

 movefile(files_n(i).name,'Noisy');
 movefile(files_e(i).name,'Noisy');
 movefile(files_z(i).name,'Noisy');

 i=i+1;
 
 if i>max
     close all;
     return;
 end

%  full_name=fullfile(pwd,files_z(i).name);
%  [tz ys_z p]=readsac(full_name);
%  full_name=fullfile(pwd,files_e(i).name);
%  [te ys_e p]=readsac(full_name);
%  full_name=fullfile(pwd,files_n(i).name); 
%  [tn ys_n p]=readsac(full_name);
%  
%  h1=handles.axes1;
%  h2=handles.axes2;
%  h3=handles.axes3;
%  title(files_z(i).name)
%  plot(h1,tz,ys_z);
%  plot(h2,te,ys_e);
%  plot(h3,tn,ys_n);
 
  full_name=fullfile(pwd,files_z(i).name);
 ys_z=rsac(full_name);
 full_name=fullfile(pwd,files_e(i).name);
 ys_e=rsac(full_name);
 full_name=fullfile(pwd,files_n(i).name); 
 ys_n=rsac(full_name);
 
 h1=handles.axes1;
 h2=handles.axes2;
 h3=handles.axes3;
 
 [f_z,X_z]=FFourier(ys_z.d,1./ys_z.dt);
% Commented lines by DRLA 
  semilogx(h1,f_z,2*abs(X_z)); ylabel('FFT');
  plot(h2,ys_z.t,ys_z.d); ylabel('Vertical');
  plot(h3,ys_n.t,ys_n.d,ys_e.t,ys_e.d); ylabel('Horizontal');
 
 

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
close all
return
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


