function varargout = equalizer(varargin)
% EQUALIZER MATLAB code for equalizer.fig
%      EQUALIZER, by itself, creates a new EQUALIZER or raises the existing
%      singleton*.
%
%      H = EQUALIZER returns the handle to a new EQUALIZER or the handle to
%      the existing singleton*.
%
%      EQUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUALIZER.M with the given input arguments.
%
%      EQUALIZER('Property','Value',...) creates a new EQUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before equalizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to equalizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help equalizer

% Last Modified by GUIDE v2.5 25-Aug-2021 14:20:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @equalizer_OpeningFcn, ...
                   'gui_OutputFcn',  @equalizer_OutputFcn, ...
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


% --- Executes just before equalizer is made visible.
function equalizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to equalizer (see VARARGIN)

% Choose default command line output for equalizer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes equalizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = equalizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in import_audio.
function import_audio_Callback(hObject, eventdata, handles)
% hObject    handle to import_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, filepath] = uigetfile({'*.*';'*.mp3';'*.ogg';},'Busque un archivo de audio');
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;

[x, fs] = read_file([filepath filename]);
type_audio = 1;
decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
amps = 10.^(decibels./10);
n = length(x);
t = (0:n-1)/fs;
if get(handles.window_type, 'Value') == 1
    [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
else
    [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
end
axes(handles.time_amp_old)
plot(t,x);
grid on
xlabel('Tiempo [s]')
ylabel('Amplitud [u.a.]')
title('Señal de sonido original')
axes(handles.time_amp_new)
plot(t,y);
grid on
xlabel('Tiempo [s]')
ylabel('Amplitud [u.a.]')
title('Señal de sonido modificado')
axes(handles.freq_amp_old)
plot(f,abs(Fxs));
grid on
xlabel('Frecuencia (Hz)')
ylabel('Amplitud [u.a.]')
title('Señal de sonido original')
axes(handles.freq_amp_new)
plot(f,abs(new_Fxs));
grid on
xlabel('Frecuencia (Hz)')
ylabel('Amplitud [u.a.]')
title('Señal de sonido modificado')




% --- Executes on button press in record_audio.
function record_audio_Callback(hObject, eventdata, handles)
% hObject    handle to record_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;

[x, fs] = get_file(str2double(get(handles.record_time,'String')));
type_audio = 0;
decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
amps = 10.^(decibels./10);
n = length(x);
t = (0:n-1)/fs;
if get(handles.window_type, 'Value') == 1
    [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
else
    [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
end
axes(handles.time_amp_old)
plot(t,x);
grid on
xlabel('Tiempo [s]')
ylabel('Amplitud [u.a.]')
title('Señal de sonido original')
axes(handles.time_amp_new)
plot(t,y);
grid on
xlabel('Tiempo [s]')
ylabel('Amplitud [u.a.]')
title('Señal de sonido modificado')
axes(handles.freq_amp_old)
plot(f,abs(Fxs));
grid on
xlabel('Frecuencia (Hz)')
ylabel('Amplitud [u.a.]')
title('Señal de sonido original')
axes(handles.freq_amp_new)
plot(f,abs(new_Fxs));
grid on
xlabel('Frecuencia (Hz)')
ylabel('Amplitud [u.a.]')
title('Señal de sonido modificado')


function record_time_Callback(hObject, eventdata, handles)
% hObject    handle to record_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of record_time as text
%        str2double(get(hObject,'String')) returns contents of record_time as a double


% --- Executes during object creation, after setting all properties.
function record_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to record_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_31_Callback(hObject, eventdata, handles)
% hObject    handle to slider_31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_31,'String',round(get(handles.slider_31,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end

% --- Executes during object creation, after setting all properties.
function slider_31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_63_Callback(hObject, eventdata, handles)
% hObject    handle to slider_63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_63,'String',round(get(handles.slider_63,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_63_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_125_Callback(hObject, eventdata, handles)
% hObject    handle to slider_125 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_125,'String',round(get(handles.slider_125,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_125_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_125 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_250_Callback(hObject, eventdata, handles)
% hObject    handle to slider_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_250,'String',round(get(handles.slider_250,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_250_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_500_Callback(hObject, eventdata, handles)
% hObject    handle to slider_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_500,'String',round(get(handles.slider_500,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_500_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_1k_Callback(hObject, eventdata, handles)
% hObject    handle to slider_1k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_1k,'String',round(get(handles.slider_1k,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_1k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_1k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_2k_Callback(hObject, eventdata, handles)
% hObject    handle to slider_2k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_2k,'String',round(get(handles.slider_2k,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_2k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_2k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_4k_Callback(hObject, eventdata, handles)
% hObject    handle to slider_4k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_4k,'String',round(get(handles.slider_4k,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_4k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_4k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_8k_Callback(hObject, eventdata, handles)
% hObject    handle to slider_8k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_8k,'String',round(get(handles.slider_8k,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_8k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_8k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_16k_Callback(hObject, eventdata, handles)
% hObject    handle to slider_16k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    set(handles.band_16k,'String',round(get(handles.slider_16k,'Value'),2));
    decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
    amps = 10.^(decibels./10);
    n = length(x);
    t = (0:n-1)/fs;
    if get(handles.window_type, 'Value') == 1
        [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
    else
        [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
    end
    axes(handles.time_amp_old)
    plot(t,x);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.time_amp_new)
    plot(t,y);
    grid on
    xlabel('Tiempo [s]')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')
    axes(handles.freq_amp_old)
    plot(f,abs(Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido original')
    axes(handles.freq_amp_new)
    plot(f,abs(new_Fxs));
    grid on
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud [u.a.]')
    title('Señal de sonido modificado')

catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes during object creation, after setting all properties.
function slider_16k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_16k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in reproduce_original.
function reproduce_original_Callback(hObject, eventdata, handles)
% hObject    handle to reproduce_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    sound(x,fs);
catch
    warning('Asegurese de primero importar o grabar audio.')
end

    

% --- Executes on button press in reproduce_modified.
function reproduce_modified_Callback(hObject, eventdata, handles)
% hObject    handle to reproduce_modified (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
try
    sound(y,fs);
catch
    warning('Asegurese de primero importar o grabar audio.')
end


% --- Executes on selection change in window_type.
function window_type_Callback(hObject, eventdata, handles)
% hObject    handle to window_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns window_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from window_type
global x;
global fs;
global n;
global t;
global Fxs;
global f;
global y;
global new_Fxs;
global type_audio;
decibels = [get(handles.slider_31,'Value'), get(handles.slider_63,'Value'), get(handles.slider_125,'Value'), get(handles.slider_250,'Value'), get(handles.slider_500,'Value'), get(handles.slider_1k,'Value'), get(handles.slider_2k,'Value'), get(handles.slider_4k,'Value'), get(handles.slider_8k,'Value'), get(handles.slider_16k,'Value')];
amps = 10.^(decibels./10);
n = length(x);
t = (0:n-1)/fs;
if get(handles.window_type, 'Value') == 1
    [Fxs, f, y, new_Fxs] = rectangular_window(x,fs,type_audio,amps);
else
    [Fxs, f, y, new_Fxs] = hanning_window(x,fs,type_audio,amps);
end
axes(handles.time_amp_old)
plot(t,x);
grid on
xlabel('Tiempo [s]')
ylabel('Amplitud [u.a.]')
title('Señal de sonido original')
axes(handles.time_amp_new)
plot(t,y);
grid on
xlabel('Tiempo [s]')
ylabel('Amplitud [u.a.]')
title('Señal de sonido modificado')
axes(handles.freq_amp_old)
plot(f,abs(Fxs));
grid on
xlabel('Frecuencia (Hz)')
ylabel('Amplitud [u.a.]')
title('Señal de sonido original')
axes(handles.freq_amp_new)
plot(f,abs(new_Fxs));
grid on
xlabel('Frecuencia (Hz)')
ylabel('Amplitud [u.a.]')
title('Señal de sonido modificado')


% --- Executes during object creation, after setting all properties.
function window_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
