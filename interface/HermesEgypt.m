function varargout = HermesEgypt(varargin)
% HERMESEGYPT MATLAB code for HermesEgypt.fig
%      HERMESEGYPT, by itself, creates a new HERMESEGYPT or raises the existing
%      singleton*.
%
%      H = HERMESEGYPT returns the handle to a new HERMESEGYPT or the handle to
%      the existing singleton*.
%
%      HERMESEGYPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HERMESEGYPT.M with the given input arguments.
%
%      HERMESEGYPT('Property','Value',...) creates a new HERMESEGYPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HermesEgypt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HermesEgypt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HermesEgypt

% Last Modified by GUIDE v2.5 26-Apr-2013 00:11:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HermesEgypt_OpeningFcn, ...
                   'gui_OutputFcn',  @HermesEgypt_OutputFcn, ...
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

function SetAllDefaults(handles)

[dir_input, dir_output, dir_results] = steganography_init();

% Images
im_white = imload([dir_input, 'white.jpg'], false);
axes(handles.image_encode);
imshow(uint8(im_white), [0 255]);
axes(handles.image_decode);
imshow(uint8(im_white), [0 255]);

setappdata(handles.figure1, 'data_image_encode', im_white);
setappdata(handles.figure1, 'data_image_encode_greyscale', im_white);
setappdata(handles.figure1, 'data_image_decode', im_white);
setappdata(handles.figure1, 'data_quality', '100');
setappdata(handles.figure1, 'data_colourspace', 'Greyscale');
%{
setappdata(handles.figure1, 'data_dimensions_x', '36');
setappdata(handles.figure1, 'data_dimensions_y', '36');
setappdata(handles.figure1, 'data_square_size', '3');
setappdata(handles.figure1, 'data_block_size', '4');
setappdata(handles.figure1, 'data_capacity', '0');
%}

% --- Executes just before HermesEgypt is made visible.
function HermesEgypt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HermesEgypt (see VARARGIN)

% Choose default command line output for HermesEgypt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HermesEgypt wait for user response (see UIRESUME)
% uiwait(handles.figure1);

SetAllDefaults(handles);

% --- Outputs from this function are returned to the command line.
function varargout = HermesEgypt_OutputFcn(hObject, eventdata, handles) 
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



function dimensions_x_Callback(hObject, eventdata, handles)
% hObject    handle to dimensions_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimensions_x as text
%        str2double(get(hObject,'String')) returns contents of dimensions_x as a double


% --- Executes during object creation, after setting all properties.
function dimensions_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimensions_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimensions_y_Callback(hObject, eventdata, handles)
% hObject    handle to dimensions_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimensions_y as text
%        str2double(get(hObject,'String')) returns contents of dimensions_y as a double


% --- Executes during object creation, after setting all properties.
function dimensions_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimensions_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in quality.
function quality_Callback(hObject, eventdata, handles)
% hObject    handle to quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns quality contents as cell array
%        contents{get(hObject,'Value')} returns selected item from quality
contents = cellstr(get(hObject,'String'));
setappdata(handles.figure1, 'data_quality', contents{get(hObject,'Value')});

% --- Executes during object creation, after setting all properties.
function quality_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in colourspace.
function colourspace_Callback(hObject, eventdata, handles)
% hObject    handle to colourspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colourspace contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colourspace
contents = cellstr(get(hObject,'String'));
setappdata(handles.figure1, 'data_colourspace', contents{get(hObject,'Value')});

axes(handles.image_encode);
if strcmp(getappdata(handles.figure1, 'data_colourspace'), 'Greyscale')
    imshow(uint8(getappdata(handles.figure1, 'data_image_encode_greyscale')), [0 255]);
else
    imshow(uint8(getappdata(handles.figure1, 'data_image_encode')), [0 255]);
end

% --- Executes during object creation, after setting all properties.
function colourspace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colourspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_decode.
function button_decode_Callback(hObject, eventdata, handles)
% hObject    handle to button_decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in browse_stego_image.
function browse_stego_image_Callback(hObject, eventdata, handles)
% hObject    handle to browse_stego_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function extracted_message_Callback(hObject, eventdata, handles)
% hObject    handle to extracted_message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of extracted_message as text
%        str2double(get(hObject,'String')) returns contents of extracted_message as a double


% --- Executes during object creation, after setting all properties.
function extracted_message_CreateFcn(hObject, eventdata, handles)
% hObject    handle to extracted_message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in copy_encoding_image.
function copy_encoding_image_Callback(hObject, eventdata, handles)
% hObject    handle to copy_encoding_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function key_1_decode_Callback(hObject, eventdata, handles)
% hObject    handle to key_1_decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of key_1_decode as text
%        str2double(get(hObject,'String')) returns contents of key_1_decode as a double


% --- Executes during object creation, after setting all properties.
function key_1_decode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to key_1_decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function key_2_decode_Callback(hObject, eventdata, handles)
% hObject    handle to key_2_decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of key_2_decode as text
%        str2double(get(hObject,'String')) returns contents of key_2_decode as a double


% --- Executes during object creation, after setting all properties.
function key_2_decode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to key_2_decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in copy_encoding_key_1.
function copy_encoding_key_1_Callback(hObject, eventdata, handles)
% hObject    handle to copy_encoding_key_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in copy_encoding_key_2.
function copy_encoding_key_2_Callback(hObject, eventdata, handles)
% hObject    handle to copy_encoding_key_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function secret_message_Callback(hObject, eventdata, handles)
% hObject    handle to secret_message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secret_message as text
%        str2double(get(hObject,'String')) returns contents of secret_message as a double


% --- Executes during object creation, after setting all properties.
function secret_message_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secret_message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_cover_image.
function browse_cover_image_Callback(hObject, eventdata, handles)
% hObject    handle to browse_cover_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, filepath] = uigetfile({'*.jpg', 'JPEG'; '*.png', 'PNG'; '*.bmp', 'BMP'; '*.*', 'All Files'}, 'Choose an image');
im = imload([filepath, filename], false);
im_greyscale = imload([filepath, filename], true);

setappdata(handles.figure1, 'data_image_encode', im);
setappdata(handles.figure1, 'data_image_encode_greyscale', im_greyscale);

axes(handles.image_encode);
if strcmp(getappdata(handles.figure1, 'data_colourspace'), 'Greyscale')
    imshow(uint8(im_greyscale), [0 255]);
else
    imshow(uint8(im), [0 255]);
end

% --- Executes on button press in button_encode.
function button_encode_Callback(hObject, eventdata, handles)
% hObject    handle to button_encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[dir_input, dir_output, dir_results] = steganography_init();

current_covermedia = getappdata(handles.figure1, 'data_image_encode');
current_covermedia_greyscale = getappdata(handles.figure1, 'data_image_encode_greyscale');

current_colourspace = getappdata(handles.figure1, 'data_colourspace');
current_quality = str2num(getappdata(handles.figure1, 'data_quality')); %#ok<ST2NM>
msg_desired = get(handles.secret_message, 'String');

if strcmp(current_colourspace, 'Greyscale')
    use_greyscale = true;
else
    use_greyscale = false;
    
    switch current_colourspace
        case 'RGB [R]'
            channel = 1;
        case 'RGB [G]'
            channel = 2;
        case 'RGB [B]'
            channel = 3;
        otherwise
            error('Invalid colourspace: %s', current_colourspace);
    end
end

fprintf('Cover media: %s\n', current_covermedia);
fprintf('Quality: %d\n', current_quality);
fprintf('Colourspace: %s\n', current_colourspace);
fprintf('Message: "%s"\n', msg_desired);

if length(msg_desired) < 1
    msg_desired = '';
end

if use_greyscale
    im = current_covermedia_greyscale;
else
    im = current_covermedia;
end

[width height ~] = size(im);

[secret_msg_bin, secret_msg_binimg, secret_msg_w, secret_msg_h, mode, block_size, pixel_size, is_binary] = steg_egypt_default(width, height, use_greyscale, msg_desired);

if use_greyscale
    imc = im;
else
    imc = im(:,:,channel);
end

[imc_stego, key1, key2, ~, ~] = steg_egypt_encode(imc, secret_msg_binimg, mode, block_size, is_binary);

if use_greyscale
    im_stego = imc_stego;
else
    im_stego = im;
    im_stego(:,:,channel) = imc_stego;
end

setappdata(handles.figure1, 'data_image_encode', im_stego);

set(handles.key_1_encode, 'String', key1);
set(handles.key_2_encode, 'String', key2);

function key_1_encode_Callback(hObject, eventdata, handles)
% hObject    handle to key_1_encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of key_1_encode as text
%        str2double(get(hObject,'String')) returns contents of key_1_encode as a double


% --- Executes during object creation, after setting all properties.
function key_1_encode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to key_1_encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function key_2_encode_Callback(hObject, eventdata, handles)
% hObject    handle to key_2_encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of key_2_encode as text
%        str2double(get(hObject,'String')) returns contents of key_2_encode as a double


% --- Executes during object creation, after setting all properties.
function key_2_encode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to key_2_encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
% hObject    handle to button_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function square_size_Callback(hObject, eventdata, handles)
% hObject    handle to square_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of square_size as text
%        str2double(get(hObject,'String')) returns contents of square_size as a double


% --- Executes during object creation, after setting all properties.
function square_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to square_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function block_size_Callback(hObject, eventdata, handles)
% hObject    handle to block_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of block_size as text
%        str2double(get(hObject,'String')) returns contents of block_size as a double


% --- Executes during object creation, after setting all properties.
function block_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to block_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in reset_all.
function reset_all_Callback(hObject, eventdata, handles)
% hObject    handle to reset_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SetAllDefaults(handles);
