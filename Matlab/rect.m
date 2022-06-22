function varargout = rect(varargin)
% RECT MATLAB code for rect.fig
%      RECT, by itself, creates a new RECT or raises the existing
%      singleton*.
%
%      H = RECT returns the handle to a new RECT or the handle to
%      the existing singleton*.
%
%      RECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECT.M with the given input arguments.
%
%      RECT('Property','Value',...) creates a new RECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rect

% Last Modified by GUIDE v2.5 22-Jun-2022 02:33:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rect_OpeningFcn, ...
                   'gui_OutputFcn',  @rect_OutputFcn, ...
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


% --- Executes just before rect is made visible.
function rect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rect (see VARARGIN)

% Choose default command line output for rect
handles.output = hObject;

% Update handles structure


guidata(hObject, handles);
axes(handles.axes1)
global im
% a=length(im(:,1,1));
imshow(im)
% global x y
[x,y]=ginput(2);
global p2 p7
p7=[min(x(1),x(2)),min(y(1),y(2))];
p2=[max(x(1),x(2)),max(y(1),y(2))];
% [eventdata.x,eventdata.y]=ginput(2);



% line([x(1),a-y(1)],[x(1),a-y(2)]);
% line([x(1),a-y(1)],[x(2),a-y(1)]);
% line([x(1),a-y(2)],[x(2),a-y(2)]);
% line([x(2),a-y(1)],[x(2),a-y(2)]);

% UIWAIT makes rect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rect_OutputFcn(hObject, eventdata, handles) 
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
% global p2 p7 x y
% p7=[min(x(1),x(2)),min(y(1),y(2))];
% p2=[max(x(1),x(2)),max(y(1),y(2))];
% % global p2 p7
% % p7=[min(eventdata.x(1),eventdata.x(2)),min(eventdata.y(1),eventdata.y(2))];
% % p2=[max(eventdata.x(1),eventdata.x(2)),max(eventdata.y(1),eventdata.y(2))];
%  delete(hObject)
% % close(rect)





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
