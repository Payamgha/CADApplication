function varargout = FinalProject(varargin)
% FINALPROJECT MATLAB code for FinalProject.fig
%      FINALPROJECT, by itself, creates a new FINALPROJECT or raises the existing
%      singleton*.
%
%      H = FINALPROJECT returns the handle to a new FINALPROJECT or the handle to
%      the existing singleton*.
%
%      FINALPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALPROJECT.M with the given input arguments.
%
%      FINALPROJECT('Property','Value',...) creates a new FINALPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FinalProject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FinalProject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FinalProject

% Last Modified by GUIDE v2.5 19-May-2017 14:57:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FinalProject_OpeningFcn, ...
    'gui_OutputFcn',  @FinalProject_OutputFcn, ...
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


% --- Executes just before FinalProject is made visible.
function FinalProject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FinalProject (see VARARGIN)

% Choose default command line output for FinalProject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FinalProject wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% initializing the parameteres
init(hObject, eventdata, handles);

% --- Outputs from this function are returned to the command line.
function varargout = FinalProject_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonDraw.
function buttonDraw_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pID;
global guiMode;

if (pID > 1)
    drawCurve();
    guiMode = 11;
    set(handles.uiModel,'visible','On');
    set(handles.buttonReset,'visible','On');
    set(handles.buttonSegToggle,'visible','On');
    set(handles.buttonEdit,'visible','On');
    errorShow(' ', handles, 0);
else
    errorShow('Enter at least two control point!', handles, 1);
end

% --- Executes on button press in buttonEdit.
function buttonEdit_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiMode;
if (guiMode == 11)
    guiMode = 12;
    errorShow(sprintf('Interactive Mode: move control points using mouse.'), handles, 0);
end


% --- Executes on button press in buttonReset.
function buttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to buttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
init(hObject, eventdata, handles);

% --- Show error message.
function  errorShow(textMessage, handles, isError)
set(handles.txtErrorWindow, 'String', textMessage);
if (isError)
    set(handles.txtErrorWindow, 'ForegroundColor', 'r');
else
    set(handles.txtErrorWindow, 'ForegroundColor', 'b');
end


% --- Executes on button press in buttonRevolve.
function buttonRevolve_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRevolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
if (guiMode >= 11)
    revolveCurve(hObject, eventdata, handles);
    set(handles.buttonExport,'visible','On');
    guiMode = 20;
else
    errorShow('Draw the curve first!', handles, 1);
end


% --- Executes on button press in buttonRotLine.
function buttonRotLine_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRotLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rotLine;
global guiMode;
rotLine.m = str2double(get(handles.valM,'String'));
rotLine.b = str2double(get(handles.valB,'String'));
if (guiMode == 11)
    cla;
    drawCurve();
    drawRotLine(hObject, eventdata, handles);
elseif (guiMode == 20)
    cla;
    revolveCurve(hObject, eventdata, handles);
    drawRotLine(hObject, eventdata, handles);
end

%% Initialization Function
function init(hObject, eventdata, handles)
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
guiMode = 0;
global pID;
pID = 0;
global segNo;
segNo = 1;
global segID;
segID = 1;
global controlPoints;
controlPoints = ones(200, 3); % To be compatible with Hom-Trans
global curvePoints;
curvePoints = []; % To be compatible with Hom-Trans
global revolvedPoints;
revolvedPoints.x = [];
revolvedPoints.y = [];
revolvedPoints.z = [];

global rotLine;
rotLine.m = 1;
rotLine.b = 0.5;

global dres;
dres = 0.01;

global resSelection;
resSelection = 100;

global axisLims; % [xMin, xMax, yMin, yMax]
cla;
axisLims = [-1 1 -1 1];
axis(axisLims);
grid on;
%set(gca,'XTick',[],'Ytick',[],'Box','on');
set(gcf,'WindowButtonDownFcn',@mouseDown,'WindowButtonMotionFcn',@mouseMoving,'WindowButtonUpFcn',@mouseUp);
view(0,90)  % XY

set(handles.uiModel,'visible','Off');
set(handles.buttonExport,'visible','Off');
set(handles.buttonReset,'visible','Off');
set(handles.buttonSegToggle,'visible','Off');
set(handles.buttonEdit,'visible','Off');

set(handles.valM,'String','0');
set(handles.valB,'String','0');
% set(handles.mirror_bVal,'String','0');
% set(handles.buttonGrid, 'String', 'Grid On');
errorShow('Enter control point by clicking on canvas.', handles, 0);
buttonSegToggle_Callback(handles.buttonSegToggle, eventdata, handles);

%% Mouse Down Event Handler
function mouseDown(hObject, eventdata, handles)
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
global pID;
global controlPoints;
global axisLims; % [xMin, xMax, yMin, yMax]
global epID;
global resSelection;
global segNo;
cp = get(gca,'CurrentPoint');
if (abs(cp(1,1))<axisLims(2) && abs(cp(1,2))<axisLims(4))
    if (guiMode == 0 || guiMode == 10)
        guiMode = 10;
        pID = pID + 1;
        controlPoints(pID,1:2) = cp(1,1:2);
        hold on;
        plot(cp(1,1),cp(1,2),'ro');
    elseif (guiMode == 12) % Move control point
        ex = ( axisLims(2) - axisLims(1) ) / resSelection;
        ey = ( axisLims(4) - axisLims(3) ) / resSelection;
        for i = 1:(segNo*pID)
            if (cp(1,1) >= controlPoints(i,1) - ex) && (cp(1,1) <= controlPoints(i,1) + ex) ...
                    && (cp(1,2) >= controlPoints(i,2) - ey) && (cp(1,2) <= controlPoints(i,2) + ey)
                epID = i;
                guiMode = 13;
            end
        end
    elseif(guiMode == 13)
        guiMode = 11;
    end
end

%% Mouse Moving Event Handler
function mouseMoving(hObject, eventdata, handles)
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
global pID;
global controlPoints;
global curvePoints;
global revolvedPoints;
global rotLine;
global axisLims; % [xMin, xMax, yMin, yMax]
global epID;
global resSelection;

if (guiMode == 13)
    cp = get(gca,'CurrentPoint'); % Change control point
    if (abs(cp(1,1))<axisLims(2) && abs(cp(1,2))<axisLims(4))
        d = rem(epID, pID);
        %         if ( d == 0 )
        %             controlPoints(epID,1:2) = cp(1,1:2);
        %             controlPoints(epID+1,1:2) = cp(1,1:2);
        %         elseif( d == 1 )
        %             controlPoints(epID,1:2) = cp(1,1:2);
        %             if (epID ~= 1)
        %                 controlPoints(epID-1,1:2) = cp(1,1:2);
        %             end
        %         else
        controlPoints(epID,1:2) = cp(1,1:2);
        %         end
        drawCurve();
        pause(0.01);
    end
end

%% Mouse Up Event Handler
function mouseUp(hObject, eventdata, handles)
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
global pID;
global controlPoints;
global curvePoints;
global revolvedPoints;
global rotLine;
global axisLims; % [xMin, xMax, yMin, yMax]


%% Draw Bezier Curve Function
function drawCurve()
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
global pID;
global segNo;
global controlPoints;
global curvePoints;
global revolvedPoints;
global rotLine;
global axisLims; % [xMin, xMax, yMin, yMax]

t = 0:0.01:1;
t = t(:);
m = rotLine.m;
b = rotLine.b;
cla;
for i = 1:segNo
    iStart = (i-1)*(pID-1) + 1;
    iEnd = (i)*(pID-1) + 1;
    %iStart = (i-1)*pID + 1;
    %iEnd = i*pID;
    P = [];
    P = controlPoints(iStart:iEnd,:);
    nP = size(P,1);
    mP = size(t,1);
    T = zeros(mP, nP-1);
    
    for j = 1:nP
        T(:,j) = t.^(nP-j);
    end
    N = getBezierCurveN(nP-1);
    singleCurvePoints = T * N * P;
    plot(singleCurvePoints(:,1), singleCurvePoints(:,2),'b');
    hold on;
    plot(P(:,1), P(:,2), 'ro');
    nP = length(singleCurvePoints(:,1));
    iStart = (i-1)*nP+1;
    iEnd = i*nP;
    curvePoints(iStart:iEnd,:) = singleCurvePoints;
end
%legend('Curve', 'ControlPoints');
%xlabel('x');
%ylabel('y');
grid on;

%% Draw revolved Curve
function revolveCurve(hObject, eventdata, handles)
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
global pID;
global controlPoints;
global curvePoints;
global revolvedPoints;
global rotLine;
global axisLims; % [xMin, xMax, yMin, yMax]
global dres;

rotLine.m = str2double(get(handles.valM,'String'))
rotLine.b = str2double(get(handles.valB,'String'))
v = 0:dres:1;

pnt = curvePoints;
size(pnt)
b = rotLine.b;
m = rotLine.m;
P = rotationZ(pnt, m, b);

%% Base
[ux, vv] = meshgrid(P(:,1),v);
[uy, vv] = meshgrid(P(:,2),v);
x = ux;
y = uy.*sin(2*pi*vv);
z = uy.*cos(2*pi*vv);

[D, M] = size(x);
Pp = [x(:), y(:), z(:)];
Ppt = invRotationZ(Pp, m, b);
xP = reshape(Ppt(:,1), [D, M]);
yP = reshape(Ppt(:,2), [D, M]);
zP = reshape(Ppt(:,3), [D, M]);
revolvedPoints.x = xP;
revolvedPoints.y = yP;
revolvedPoints.z = zP;

cla;
surf(xP,yP,zP,'FaceColor','b','EdgeColor','none'); %none
camlight left;
axis equal

%% Draw rotation axis of the revolve operation
function drawRotLine(hObject, eventdata, handles)
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
global pID;
global rotLine;
global axisLims;

if (pID > 0)
    b = rotLine.b;
    m = rotLine.m;
    t = -1:1;
    hold on;
    plot(t, m.*t+b,'r--');
    axis(axisLims);
else
    errorShow('Invalid operation: you need first draw a curve.', handles, 1);
end

%% Segmentation the curve  (two segment)
function segmentCurve()
global pID;
global segNo;
global segID;
global epID;
global controlPoints;
global curvePoints;
global alpha;
t = 0:0.01:1;
t = t(:);
P = [];
Pr = [];
iStart = (segID-1)*(pID-1) + 1;
iMiddle = (segID)*(pID-1) + 1;
iEnd = (segNo)*(pID-1) + 1;
if (iStart == 1) % First segment
    Pr1 = [];
    Pw = controlPoints(iStart:iMiddle,1:2);
    Pr2 = controlPoints(iMiddle+1:iEnd,1:2);
elseif (iEnd == iMiddle) % Last segment
    Pr1 = controlPoints(1:iStart-1,1:2);
    Pw = controlPoints(iStart:iMiddle,1:2);
    Pr2 = [];
else
    Pr1 = controlPoints(1:iStart-1,1:2);
    Pw = controlPoints(iStart:iMiddle,1:2);
    Pr2 = controlPoints(iMiddle+1:iEnd,1:2);
end
nP = size(Pw,1);
mP = size(t,1);
T = zeros(mP, nP-1);

for i = 1:nP
    T(:,i) = t.^(nP-i);
end
N = getBezierCurveN(nP-1);
newCurvePoints = T * N * Pw;

segNo = segNo + 1;

[P1 , P2] = BezierSegment(Pw, alpha);
P = [];
P = [Pr1; P1; P2(2:end,:); Pr2];
iEnd = (segNo)*(pID-1) + 1
controlPoints(1:iEnd,:) = [P, P(:,1)*0 + 1]; % HG Compatible



function valM_Callback(hObject, eventdata, handles)
% hObject    handle to valM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valM as text
%        str2double(get(hObject,'String')) returns contents of valM as a double


% --- Executes during object creation, after setting all properties.
function valM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valB_Callback(hObject, eventdata, handles)
% hObject    handle to valB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valB as text
%        str2double(get(hObject,'String')) returns contents of valB as a double


% --- Executes during object creation, after setting all properties.
function valB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to valAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valAlpha as text
%        str2double(get(hObject,'String')) returns contents of valAlpha as a double
global alpha;
dummy = str2double(get(hObject,'String'));
if (dummy <= 0)
    alpha = 0;
else
    alpha = min(dummy, 1);
end
set(hObject, 'String', num2str(alpha));
dispSegmentPoint();

% --- Executes during object creation, after setting all properties.
function valAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global alpha;
alpha = 0.5;
set(hObject, 'String', num2str(alpha));


function valSeg_Callback(hObject, eventdata, handles)
% hObject    handle to txtSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSeg as text
%        str2double(get(hObject,'String')) returns contents of txtSeg as a double
global segNo;
global segID;
dummy = floor(str2double(get(hObject,'String')));
if (dummy <= 0)
    segID = 1;
else
    segID = min(dummy, segNo);
end
set(hObject, 'String', num2str(segID));
dispSegmentPoint();

% --- Executes during object creation, after setting all properties.
function valSeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global segID;
set(hObject, 'String', num2str(segID));

function dispSegmentPoint()
global guiMode; % 0: Init, 10: Sketch, 20: 3D Mode (Revolve), 30: Export
global pID;
global segNo;
global controlPoints;
global curvePoints;
global revolvedPoints;
global rotLine;
global axisLims; % [xMin, xMax, yMin, yMax]
global alpha;
global segID;

if (guiMode == 15) % Segmentation
    t = alpha;
    m = rotLine.m;
    b = rotLine.b;
    i = segID;
    iStart = (i-1)*(pID-1) + 1;
    iEnd = (i)*(pID-1) + 1;
    P = [];
    P = controlPoints(iStart:iEnd,:);
    nP = size(P,1);
    mP = size(t,1);
    T = zeros(mP, nP-1);
    
    for j = 1:nP
        T(:,j) = t.^(nP-j);
    end
    N = getBezierCurveN(nP-1);
    singleCurvePoints = T * N * P;
    drawCurve();
    hold on;
    plot(singleCurvePoints(:,1), singleCurvePoints(:,2),'rx');
end

% --- Executes on slider movement.
function slideSeg_Callback(hObject, eventdata, handles)
% hObject    handle to slideSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global alpha;
alpha = get(hObject,'Value');
set(handles.valAlpha, 'String', num2str(alpha));
dispSegmentPoint();


% --- Executes during object creation, after setting all properties.
function slideSeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slideSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
global alpha;
alpha = 0.5;
set(hObject, 'Value', alpha);


% --- Executes on button press in buttonSegToggle.
function buttonSegToggle_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSegToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonSegToggle
global guiMode;
if(guiMode == 11)
    guiMode = 15;
    set(hObject,'BackgroundColor',[.1 .9 .1]);
    set(handles.uiSegment, 'Visible', 'On');
    dispSegmentPoint();
elseif(guiMode == 15)
    guiMode = 11;
    set(hObject,'BackgroundColor',[.9 .9 .9]);
    set(handles.uiSegment, 'Visible', 'Off');
else
    set(hObject,'BackgroundColor',[.9 .9 .9]);
    set(handles.uiSegment, 'Visible', 'Off');
end


% --- Executes on button press in buttonSegmentApply.
function buttonSegmentApply_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSegmentApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiMode;
global segNo;
if(guiMode == 15)
    segmentCurve();
    drawCurve();
    set(handles.buttonSegToggle,'BackgroundColor',[.9 .9 .9]);
    set(handles.uiSegment, 'Visible', 'Off');
    guiMode = 11;
end
if segNo > 1
    msg = sprintf('out of %c segments.', num2str(segNo));
else
    msg = sprintf('out of %c segment.', num2str(segNo));
end
set(handles.txtSegNo, 'String', msg);

% --- Executes on button press in buttonSegmentApply.
function buttonSegCancel_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSegmentApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiMode;
if(guiMode == 15)
    guiMode = 11;
    set(hObject,'BackgroundColor',[.9 .9 .9]);
    set(handles.uiSegment, 'Visible', 'Off');
end


% --- Executes during object creation, after setting all properties.
function buttonDraw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonDraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',[.9 .9 .9]);



% --- Executes during object creation, after setting all properties.
function buttonEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',[.9 .9 .9]);


% --- Executes during object creation, after setting all properties.
function buttonRevolve_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonRevolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',[.9 .9 .9]);


% --- Executes during object creation, after setting all properties.
function buttonRotLine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonRotLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',[.9 .9 .9]);


% --- Executes during object creation, after setting all properties.
function buttonReset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',[.9 .9 .9]);


% --- Executes on button press in buttonExport.
function buttonExport_Callback(hObject, eventdata, handles)
% hObject    handle to buttonExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revolvedPoints;
X = revolvedPoints.x;
Y = revolvedPoints.y;
Z = revolvedPoints.z;
filename = 'RevolvedShape.stl';
stlwrite_ET(filename, X,Y,Z);

% --- Executes during object creation, after setting all properties.
function txtSegNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSegNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global segNo;
if segNo > 1
    msg = sprintf('out of %c segments.', num2str(segNo));
else
    msg = sprintf('out of %c segment.', num2str(segNo));
end
set(hObject, 'String', msg);


% --- Executes during object creation, after setting all properties.
function buttonExport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',[.9 .9 .9]);


% --- Executes during object creation, after setting all properties.
function txtErrorWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtErrorWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
