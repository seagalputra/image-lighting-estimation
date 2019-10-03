function varargout = gui(varargin)
%GUI MATLAB code file for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('Property','Value',...) creates a new GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI('CALLBACK') and GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 22-Sep-2019 12:47:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in grayscale.
function grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img; global img_gray;
img_gray = rgb2gray(img);

axes(handles.axes_segmentation);
imshow(img_gray);

% --- Executes on button press in open_image.
function open_image_Callback(hObject, eventdata, handles)
% hObject    handle to open_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
[filename, path] = uigetfile({'*.png;*.jpg;*.tif','Image Files'});
img = imread(fullfile(path,filename));

axes(handles.axes_original);
imshow(img);

% --- Executes on button press in segmentation.
function segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global bw;
% create progress dialog
f = waitbar(0,'Please Wait...');
waitbar(.25,f,'Segmenting image');
% call segmentation function
[bw, mask] = segment_image(img);
% bw = kmeans_seg(img,3,3);
waitbar(.75,f,'Almost ready');
waitbar(1,f,'Done');
% close progress dialog
close(f);

axes(handles.axes_segmentation);
imshow(mask);
% imshow(bw);

% --- Executes on button press in normal.
function normal_Callback(hObject, eventdata, handles)
% hObject    handle to normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img; global bw; global x; global y; global nx; global ny;
global center;

size_threshold = 500;
% remove unnecessary region
bw = bwareaopen(bw, size_threshold);

% suppose image is circular
[center, radius] = circular(bw);

axes(handles.axes_normal);
imshow(img);
hold on;
for i = 1:size(center,1)
    [x, y, nx, ny, theta] = fit_circular(center(i,:), radius);    
    plot(x, y, 'r.');
    
    % plot surface normal every points
    for j = 1:length(theta)
        line( [x(j) x(j)+nx(j)], [y(j) y(j)+ny(j)] );
    end
end

% --- Executes on button press in estimate_light.
function estimate_light_Callback(hObject, eventdata, handles)
% hObject    handle to estimate_light (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img; global img_gray; global nx; global ny; global x; global y;
global center;
n_points = 3;
N = [nx', ny'];
N = mat2cell(N,repmat(n_points,1,size(N,1)/n_points),2);

% obtain intensity image
length = 5000; % length line to plot
offset = 15;
boundary = extrapolation(img_gray, x, y, nx, ny, offset);
L = infinite_light(N, boundary);
% set static text
set(handles.lx_coordinate, 'String', num2str(L(1)));
set(handles.ly_coordinate, 'String', num2str(L(2)));
% plot image
axes(handles.axes_light);
imshow(img);
hold on;
line([center(1,1) center(1,1)+L(1)*length], [center(1,2) center(1,2)+L(2)*length], 'Color', 'red', ...
    'LineWidth', 3);
