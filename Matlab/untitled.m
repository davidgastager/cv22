function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 22-Jun-2022 11:23:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)
set(handles.axes_img,'visible','off');

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global im


% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.



% --- Executes on button press in pushbutton_img.
function pushbutton_img_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes_img);
[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'});
str=[pathname filename];
global im
im = imread(str);
imshow(im)


% --- Executes on button press in pushbutton_rect.
function pushbutton_rect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% open('rect.fig')
% h=gcf;
% pushbutton_rect;
% set(rect,'Visilabe','on')
set(rect)
% h = guihandles;
% set(h.axes1,imshow(im))

% h=guihandels;


% --- Executes on button press in pushbutton_vp.
function pushbutton_vp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_vp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(vp)

% --- Executes on button press in pushbutton_run.
function pushbutton_run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p2 p7 vp im
vp=floor(vp);
p2=floor(p2);
p7=floor(p7);

[img_left,img_right,img_ceil,img_floor,img_rect]= box(vp,p7,p2,1200,im);
% [lw_rect,rw_rect,c_rect,f_rect,in_rect]=[img_left,img_right,img_ceil,img_floor,img_rect];
lw_rect=img_left;
rw_rect=img_right;
c_rect=img_ceil;
f_rect=img_floor;
in_rect=img_rect;
[lw_height,lw_length]=size(img_left(:,:,1));
[rw_height,rw_length]=size(img_right(:,:,1));
[c_height,c_length]=size(img_ceil(:,:,1));
[f_height,f_length]=size(img_floor(:,:,1));


figure;
xlabel('x');
ylabel('y');
zlabel('z');
axis on;
% Inner rectangle plotting
[in_height,in_length,~]=size(in_rect);
g_in = hgtransform('Matrix',makehgtform('translate',[0 0 in_height],'xrotate',-pi/2));
image(g_in,in_rect);
hold on;
%Left wall plotting
g_lw = hgtransform('Matrix',makehgtform('translate',[0 -lw_length lw_height],'zrotate',pi/2,'xrotate',-pi/2));
image(g_lw,lw_rect);
hold on;
%Ceiling plotting
g_c = hgtransform('Matrix',makehgtform('translate',[0 -c_height in_height]));
image(g_c,c_rect);
hold on;
%right wall plotting
g_rw = hgtransform('Matrix',makehgtform('translate',[in_length 0 rw_height],'zrotate',-pi/2,'xrotate',-pi/2));
image(g_rw,rw_rect);
hold on;
%floor plotting
g_f = hgtransform('Matrix',makehgtform('xrotate',pi));
image(g_f,f_rect);
hold on;
view(3)
