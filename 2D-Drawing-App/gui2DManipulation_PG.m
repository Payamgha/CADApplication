function varargout = gui2DManipulation_PG(varargin)
% GUI2DMANIPULATION_PG MATLAB code for gui2DManipulation_PG.fig
%      GUI2DMANIPULATION_PG, by itself, creates a new GUI2DMANIPULATION_PG or raises the existing
%      singleton*.
%
%      H = GUI2DMANIPULATION_PG returns the handle to a new GUI2DMANIPULATION_PG or the handle to
%      the existing singleton*.
%
%      GUI2DMANIPULATION_PG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2DMANIPULATION_PG.M with the given input arguments.
%
%      GUI2DMANIPULATION_PG('Property','Value',...) creates a new GUI2DMANIPULATION_PG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2DManipulation_PG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2DManipulation_PG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% February 22, 2017

% Edit the above text to modify the response to help gui2DManipulation_PG

% Last Modified by GUIDE v2.5 23-Feb-2017 17:42:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2DManipulation_PG_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2DManipulation_PG_OutputFcn, ...
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


% --- Executes just before gui2DManipulation_PG is made visible.
function gui2DManipulation_PG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2DManipulation_PG (see VARARGIN)

% Choose default command line output for gui2DManipulation_PG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2DManipulation_PG wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% initializing the parameteres
global ghandles;
global pID;
global guiMode; % 0: Idle, 1: Drawing, 2: Patched, 3: Translation
global sketchID;
global patchPoints;
global originalPatchPoints;
global oldValues; % 1: TransX, TransY, Rot, ScaleX, 5:ScaleY, ShearX, ShearY
global transVector; % [x0, x1; y0, y1]
global axisLims; % [xMin, xMax, yMin, yMax]

oldValues = zeros(7,1);
oldValues(4:5) = ones(2,1);
guiMode = 0;
ghandles = handles;
axisLims = [-1 1 -1 1];
axis(axisLims); 
hold on;
set(gca,'XTick',[],'Ytick',[],'Box','on');
set(gcf,'WindowButtonDownFcn',@mouseDown,'WindowButtonMotionFcn',@mouseMoving,'WindowButtonUpFcn',@mouseUp);
set(handles.buttonPatch,'visible','On');
set(handles.buttonReset,'visible','Off');
set(handles.buttonClear,'visible','On');
set(handles.translation_sliderX,'Value',0);
set(handles.translation_sliderY,'Value',0);
set(handles.rotation_slider,'Value',0);
set(handles.rotation_xVal,'String','0');
set(handles.rotation_yVal,'String','0');
set(handles.shear_sliderX,'Value',0);
set(handles.shear_sliderY,'Value',0);
set(handles.scale_sliderX,'Value',1);
set(handles.scale_sliderY,'Value',1);
set(handles.mirror_mVal,'String','0');
set(handles.mirror_bVal,'String','0');
set(handles.buttonGrid, 'String', 'Grid On');

originalPatchPoints = ones(3,10000); % To be compatible with Hom-Trans
pID = 0;
sketchID = 0;
patchPoints = [];
errorShow('Draw your object using mouse, then hit Patch.', handles, 0);

%% User Defined Function
function mouseDown(hObject, eventdata, handles)
global guiMode; % 0: Idle, 1: Drawing, 2: Patched, 3: Translation
global transVector; % [x0, x1; y0, y1]
global axisLims; % [xMin, xMax, yMin, yMax]
cp = get(gca,'CurrentPoint');
if (abs(cp(1,1))<axisLims(2) && abs(cp(1,2))<axisLims(4))
    if(guiMode == 0)
        guiMode = 1;
    elseif (guiMode == 3)
        transVector(:,1) = cp(1,1:2)'
        guiMode = 4;
    end
end

function mouseMoving(hObject, eventdata, handles)
global pID;
global originalPatchPoints;
global guiMode; % 0: Idle, 1: Drawing, 2: Patched, 3: Translation
global transVector; % [x0, x1; y0, y1]
global axisLims; % [xMin, xMax, yMin, yMax]
global patchPoints;

cp = get(gca,'CurrentPoint');
if (abs(cp(1,1))<axisLims(2) && abs(cp(1,2))<axisLims(4))
if (guiMode == 1)
    pID = pID + 1;
    originalPatchPoints(1,pID) = cp(1,1);
    originalPatchPoints(2,pID) = cp(1,2);
    plot(cp(1,1),cp(1,2),'k.');
elseif (guiMode == 4)
transVector(:,2) = cp(1,1:2)';
patchPoints = patchPoints + [transVector(:,2) - transVector(:,1); 0];
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');
    plot(cp(1,1),cp(1,2),'k.');
    
transVector(:,1) = transVector(:,2);
end
end



function mouseUp(hObject, eventdata, handles)
global guiMode; % 0: Idle, 1: Drawing, 2: Patched, 3: Translation

if (guiMode == 1)
    guiMode = 0;
elseif (guiMode == 4)
guiMode = 3;
end

%% GUI-related Functions
% --- Outputs from this function are returned to the command line.
function varargout = gui2DManipulation_PG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function translation_sliderX_Callback(hObject, eventdata, handles)
% hObject    handle to translation_sliderX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global patchPoints;

transX = get(hObject,'Value')
set(hObject,'String',num2str(transX));
transX = convertAbs2Rel(transX, 1);
patchPoints = patchPoints + [transX; 0; 0];
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');


% --- Executes during object creation, after setting all properties.
function translation_sliderX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to translation_sliderX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function translation_sliderY_Callback(hObject, eventdata, handles)
% hObject    handle to translation_sliderY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global patchPoints;

transY = get(hObject,'Value')
transY = convertAbs2Rel(transY, 2);
patchPoints = patchPoints + [0; transY; 0];
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');


% --- Executes during object creation, after setting all properties.
function translation_sliderY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to translation_sliderY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function scale_sliderX_Callback(hObject, eventdata, handles)
% hObject    handle to scale_sliderX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global patchPoints;

scaleX = get(hObject,'Value');
scaleX = convertAbs2Rel(scaleX, 4);
T = Scale_PG(scaleX, 1);
patchPoints = T * patchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');


% --- Executes during object creation, after setting all properties.
function scale_sliderX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scale_sliderX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function scale_sliderY_Callback(hObject, eventdata, handles)
% hObject    handle to scale_sliderY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global patchPoints;

scaleY = get(hObject,'Value');
scaleY = convertAbs2Rel(scaleY, 5);
T = Scale_PG(1, scaleY);
patchPoints = T * patchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');


% --- Executes during object creation, after setting all properties.
function scale_sliderY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scale_sliderY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function shear_sliderX_Callback(hObject, eventdata, handles)
% hObject    handle to shear_sliderX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global patchPoints;

shearX = get(hObject,'Value');
shearX = convertAbs2Rel(shearX, 6);
T = Shear_PG(1, 90);
patchPoints = T * patchPoints;
if (shearX >= 0)
    T = Shear_PG(1, 90 - shearX);
else
    T = Shear_PG(1, abs(shearX) - 90);
end
patchPoints = T * patchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');


% --- Executes during object creation, after setting all properties.
function shear_sliderX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shear_sliderX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function shear_sliderY_Callback(hObject, eventdata, handles)
% hObject    handle to shear_sliderY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global patchPoints;
global oldValues; % 1: TransX, TransY, Rot, ScaleX, 5:ScaleY, ShearX, ShearY

shearY = get(hObject,'Value');
shearY = convertAbs2Rel(shearY, 7);
T = Shear_PG(2, 90);
patchPoints = T * patchPoints;
if (shearY >= 0)
    T = Shear_PG(2, 90 - shearY);
else
    T = Shear_PG(2, abs(shearY) - 90);
end
patchPoints = T * patchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');


% --- Executes during object creation, after setting all properties.
function shear_sliderY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shear_sliderY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function rotation_slider_Callback(hObject, eventdata, handles)
% hObject    handle to rotation_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global patchPoints;

angle = get(hObject,'Value');
angle = convertAbs2Rel(angle, 3);
xRot = str2double(get(handles.rotation_xVal,'String'));
yRot = str2double(get(handles.rotation_yVal,'String'));
R = RotationPnt_PG(angle, xRot, yRot);
patchPoints = R * patchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');
plot(xRot,yRot,'x');

% --- Executes during object creation, after setting all properties.
function rotation_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function mirror_mVal_Callback(hObject, eventdata, handles)
% hObject    handle to mirror_mVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mirror_mVal as text
%        str2double(get(hObject,'String')) returns contents of mirror_mVal as a double

% --- Executes during object creation, after setting all properties.
function mirror_mVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mirror_mVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mirror_bVal_Callback(hObject, eventdata, handles)
% hObject    handle to mirror_bVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mirror_bVal as text
%        str2double(get(hObject,'String')) returns contents of mirror_bVal as a double


% --- Executes during object creation, after setting all properties.
function mirror_bVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mirror_bVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mirror_x.
function mirror_x_Callback(hObject, eventdata, handles)
% hObject    handle to mirror_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global patchPoints;

T = Mirror_PG(1);
patchPoints = T * patchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');


% --- Executes on button press in scale_y.
function mirror_y_Callback(hObject, eventdata, handles)
% hObject    handle to scale_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global patchPoints;

T = Mirror_PG(2);
patchPoints = T * patchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');


% --- Executes on button press in mirror_line.
function mirror_line_Callback(hObject, eventdata, handles)
% hObject    handle to mirror_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global patchPoints;
global originalPatchPoints;

b = str2double(get(handles.mirror_bVal,'String'));
m = str2double(get(handles.mirror_mVal,'String'));
T = MirrorLine_PG(m, b);
patchPoints = T * patchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');



function rotation_xVal_Callback(hObject, eventdata, handles)
% hObject    handle to rotation_xVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotation_xVal as text
%        str2double(get(hObject,'String')) returns contents of rotation_xVal as a double


% --- Executes during object creation, after setting all properties.
function rotation_xVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation_xVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotation_yVal_Callback(hObject, eventdata, handles)
% hObject    handle to rotation_yVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotation_yVal as text
%        str2double(get(hObject,'String')) returns contents of rotation_yVal as a double


% --- Executes during object creation, after setting all properties.
function rotation_yVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation_yVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonPatch.
function buttonPatch_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pID;
global originalPatchPoints;
global patchPoints;
global guiMode; % 0: Idle, 1: Drawing, 2: Patched, 3: Translation
if (pID > 1)
    guiMode = 2;
if pID < 10000
    originalPatchPoints(:,pID+1:end)=[];
end
patch(originalPatchPoints(1,:),originalPatchPoints(2,:),'r')
patchPoints = originalPatchPoints;
set(hObject, 'Visible' ,'Off');
set(handles.buttonReset,'Visible','On');
errorShow(sprintf(' Interactive Mode: move object using mouse.\n Reset: restore original shape.\n New: Strat to draw a new shape.'), handles, 0);
else
    errorShow('You should draw at least 2 points',handles, 1);
end

% --- Executes on button press in buttonReset.
function buttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to buttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global patchPoints;
global originalPatchPoints;
global guiMode; % 0: Idle, 1: Drawing, 2: Patched, 3: Translation
patchPoints = originalPatchPoints;
cla;
patch(patchPoints(1,:),patchPoints(2,:),'r');
set(hObject, 'Visible' ,'On');
set(handles.buttonPatch,'Visible','Off');
set(handles.buttonClear,'visible','On');
set(handles.translation_sliderX,'Value',0);
set(handles.translation_sliderY,'Value',0);
set(handles.rotation_slider,'Value',0);
set(handles.rotation_xVal,'String','0');
set(handles.rotation_yVal,'String','0');
set(handles.shear_sliderX,'Value',0);
set(handles.shear_sliderY,'Value',0);
set(handles.scale_sliderX,'Value',1);
set(handles.scale_sliderY,'Value',1);
set(handles.mirror_mVal,'String','0');
set(handles.mirror_bVal,'String','0');
set(handles.buttonModeTranslation,'BackgroundColor',[.94, .94, .94]);
guiMode = 2;
errorShow(sprintf(' Interactive Mode: move object using mouse.\n Reset: restore original shape.\n New: Strat to draw a new shape.'), handles, 0);

% --- Executes on button press in buttonClear.
function buttonClear_Callback(hObject, eventdata, handles)
% hObject    handle to buttonClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global patchPoints;
global originalPatchPoints;
global pID;
global sketchID;
global guiMode; % 0: Idle, 1: Drawing, 2: Patched, 3: Translation
guiMode = 0;

cla;
originalPatchPoints = ones(3,10000); % To be compatible with Hom-Trans
patchPoints = originalPatchPoints;
pID = 0;
sketchID = 0;
set(handles.buttonPatch,'visible','On');
set(handles.buttonReset,'visible','Off');
set(handles.buttonClear,'visible','On');
set(handles.translation_sliderX,'Value',0);
set(handles.translation_sliderY,'Value',0);
set(handles.rotation_slider,'Value',0);
set(handles.rotation_xVal,'String','0');
set(handles.rotation_yVal,'String','0');
set(handles.shear_sliderX,'Value',0);
set(handles.shear_sliderY,'Value',0);
set(handles.scale_sliderX,'Value',1);
set(handles.scale_sliderY,'Value',1);
set(handles.mirror_mVal,'String','0');
set(handles.mirror_bVal,'String','0');
set(handles.buttonModeTranslation,'BackgroundColor',[.94, .94, .94]);
errorShow('Draw your object using mouse, then hit Patch.', handles, 0);

% --- Executes on button press in buttonModeTranslation.
function buttonModeTranslation_Callback(hObject, eventdata, handles)
% hObject    handle to buttonModeTranslation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiMode; % 0: Idle, 1: Drawing, 2: Patched, 3: Translation
if (guiMode == 2)
    guiMode = 3;
    set(hObject,'BackgroundColor',[0, 1, 0]);
elseif (guiMode == 3)
    guiMode = 2;
    set(hObject,'BackgroundColor',[.94, .94, .94]);
end

% --- Convert absolute value to relative one.
function [ out ] = convertAbs2Rel(termValue, termIndex)
global oldValues; % 1: TransX, TransY, Rot, ScaleX, 5:ScaleY, ShearX, ShearY
if (termIndex == 4) || (termIndex == 5)
    out = termValue/oldValues(termIndex);
else
    out = termValue - oldValues(termIndex);
end
oldValues(termIndex) = termValue;


% --- Show error message.
function  errorShow(textMessage, handles, isError)
set(handles.txtErrorWindow, 'String', textMessage);
if (isError)
    set(handles.txtErrorWindow, 'ForegroundColor', 'r');
else
    set(handles.txtErrorWindow, 'ForegroundColor', 'b');
end


% --- Executes on button press in buttonGrid.
function buttonGrid_Callback(hObject, eventdata, handles)
% hObject    handle to buttonGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject, 'String'), 'Grid On')
set(hObject, 'String', 'Grid Off');
set(handles.mainAxes,'XTick', [-1 -.5 0 .5 1],'YTick', [-1 -.5 0 .5 1],'XGrid','On','YGrid','On');
else
set(hObject, 'String', 'Grid On');
set(handles.mainAxes,'XTick', [],'YTick', [],'XGrid','Off','YGrid','Off');
end
