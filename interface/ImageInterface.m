function varargout = ImageInterface(varargin)
% IMAGEINTERFACE MATLAB code for ImageInterface.fig
%      IMAGEINTERFACE, by itself, creates a new IMAGEINTERFACE or raises the existing
%      singleton*.
%
%      H = IMAGEINTERFACE returns the handle to a new IMAGEINTERFACE or the handle to
%      the existing singleton*.
%
%      IMAGEINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEINTERFACE.M with the given input arguments.
%
%      IMAGEINTERFACE('Property','Value',...) creates a new IMAGEINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageInterface

% Last Modified by GUIDE v2.5 25-Apr-2013 23:17:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageInterface_OutputFcn, ...
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

function SetAllToDefaults(handles)
[dir_input, dir_output, dir_results] = steganography_init();

% Default values
setappdata(handles.figure1, 'current_algorithm', 'al_lsb');
setappdata(handles.figure1, 'current_covermedia', 'cm_lena');
setappdata(handles.figure1, 'custom_filename', '');
setappdata(handles.figure1, 'custom_filepath', '');
setappdata(handles.figure1, 'current_quality', '100');
setappdata(handles.figure1, 'current_colourspace', 'Greyscale');

% Statistics
set(handles.msg_output, 'String', '');
set(handles.status, 'String', '');

% Images
im_white = imload([dir_input, 'white.jpg'], false);
axes(handles.im_input);
imshow(uint8(im_white), [0 255]);
axes(handles.im_output);
imshow(uint8(im_white), [0 255]);

set(handles.panel_algorithm, 'SelectedObject', handles.al_lsb);
set(handles.panel_covermedia, 'SelectedObject', handles.cm_lena);
set(handles.quality, 'Value', 1);
set(handles.colourspace, 'Value', 1);


% --- Executes just before ImageInterface is made visible.
function ImageInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageInterface (see VARARGIN)

% Choose default command line output for ImageInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);

SetAllToDefaults(handles);

% --- Outputs from this function are returned to the command line.
function varargout = ImageInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in al_lsb.
function al_lsb_Callback(hObject, eventdata, handles)
% hObject    handle to al_lsb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of al_lsb


% --- Executes on button press in al_dct.
function al_dct_Callback(hObject, eventdata, handles)
% hObject    handle to al_dct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of al_dct


% --- Executes on button press in al_zk.
function al_zk_Callback(hObject, eventdata, handles)
% hObject    handle to al_zk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of al_zk


% --- Executes on button press in al_wdct.
function al_wdct_Callback(hObject, eventdata, handles)
% hObject    handle to al_wdct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of al_wdct


% --- Executes on button press in al_fusion.
function al_fusion_Callback(hObject, eventdata, handles)
% hObject    handle to al_fusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of al_fusion


% --- Executes on button press in al_egypt.
function al_egypt_Callback(hObject, eventdata, handles)
% hObject    handle to al_egypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of al_egypt


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function msg_input_Callback(hObject, eventdata, handles)
% hObject    handle to msg_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msg_input as text
%        str2double(get(hObject,'String')) returns contents of msg_input as a double


% --- Executes during object creation, after setting all properties.
function msg_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msg_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.status, 'String', 'Running...');

[dir_input, dir_output, dir_results] = steganography_init();

secret_msg_str = '';

current_algorithm = getappdata(handles.figure1, 'current_algorithm');
current_covermedia = getappdata(handles.figure1, 'current_covermedia');
current_quality = str2num(getappdata(handles.figure1, 'current_quality'));
current_colourspace = getappdata(handles.figure1, 'current_colourspace');
msg_desired = get(handles.msg_input, 'String');

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

fprintf('Algorithm: %s\n', current_algorithm);
fprintf('Cover media: %s\n', current_covermedia);
fprintf('Quality: %d\n', current_quality);
fprintf('Colourspace: %s\n', current_colourspace);
fprintf('Message: "%s"\n', msg_desired);

% The default functions require an argument of '' in order to generate
% their own secret message. This step is for some reason required to ensure
% that they string is indeed equal to ''.
if length(msg_desired) < 1
    msg_desired = '';
end

valid_covermedia = true;
switch current_covermedia
    case 'cm_lena'
        carrier_image_filename = [dir_input, 'lena.jpg'];
        output_image_filename = [dir_output, 'lena_gui.jpg'];
    case 'cm_peppers'
        carrier_image_filename = [dir_input, 'peppers.jpg'];
        output_image_filename = [dir_output, 'peppers_gui.jpg'];
    case 'cm_white'
        carrier_image_filename = [dir_input, 'white.jpg'];
        output_image_filename = [dir_output, 'white_gui.jpg'];
    case 'cm_custom'
        custom_filename = getappdata(handles.figure1, 'custom_filename');
        custom_filepath = getappdata(handles.figure1, 'custom_filepath');
        carrier_image_filename = [custom_filepath, custom_filename];
        output_image_filename = [dir_output, custom_filename];
        
        if strcmp(custom_filename, '')
            valid_covermedia = false;
        end
    otherwise
        valid_covermedia = false;
end

if valid_covermedia

    im = imload(carrier_image_filename, use_greyscale);
    [width height ~] = size(im);

    valid_algorithm = true;
    switch current_algorithm
        case 'al_lsb'
            [secret_msg_bin] = steg_lsb_default(width, height, use_greyscale, msg_desired);
        case 'al_dct'
            [secret_msg_bin, frequency_coefficients, persistence] = steg_dct_default(width, height, use_greyscale, msg_desired);
        case 'al_zk'
            [secret_msg_bin, frequency_coefficients, variance_threshold, minimum_distance_encode, minimum_distance_decode] = steg_zk_default(width, height, use_greyscale, msg_desired);
        case 'al_wdct'
            [secret_msg_bin, frequency_coefficients, persistence, mode] = steg_wdct_default(width, height, use_greyscale, msg_desired);
        case 'al_fusion'
            [secret_msg_bin, alpha, mode] = steg_fusion_default(width, height, use_greyscale, msg_desired);
        case 'al_egypt'
            [secret_msg_bin, secret_msg_binimg, secret_msg_w, secret_msg_h, mode, block_size, pixel_size, is_binary] = steg_egypt_default(width, height, use_greyscale, msg_desired);
        otherwise
            valid_algorithm = false;
    end

    if valid_algorithm
        
        % Select colour channel if necessary
        if use_greyscale
            imc = im;
        else
            imc = im(:,:,channel);
        end
        
        % Perform encoding
        tic;
        switch current_algorithm
            case 'al_lsb'
                [imc_stego] = steg_lsb_encode(imc, secret_msg_bin);
            case 'al_dct'
                [imc_stego, ~, ~] = steg_dct_encode(secret_msg_bin, imc, frequency_coefficients, persistence);
            case 'al_zk'
                [imc_stego, bits_written, ~, ~, ~] = steg_zk_encode(secret_msg_bin, imc, frequency_coefficients, variance_threshold, minimum_distance_encode);
            case 'al_wdct'
                % WDCT only works on frame size of 16
                imc_part = imc(1:floorx(height, 16), 1:floorx(width, 16));
                [imc_part, ~] = steg_wdct_encode(imc_part, secret_msg_bin, mode, frequency_coefficients, persistence);
                imc_stego = imc;
                imc_stego(1:floorx(height, 16), 1:floorx(width, 16)) = imc_part;
            case 'al_fusion'
                [imc_stego, ~, ~] = steg_fusion_encode(imc, secret_msg_bin, alpha, mode);
            case 'al_egypt'
                [imc_stego, key1, key2, ~, ~] = steg_egypt_encode(imc, secret_msg_binimg, mode, block_size, is_binary);
            otherwise
                error('No such algorithm "%s" exists for encoding.', algorithm);
        end
        encode_time = toc;
        
        
        % Switch back colour channel if necessary
        if use_greyscale
            im_stego = imc_stego;
        else
            im_stego = im;
            im_stego(:,:,channel) = imc_stego;
        end
        
        % Write
        imwrite(uint8(im_stego), output_image_filename, 'Quality', current_quality);

        % Read
        im_stego = imload(output_image_filename, use_greyscale);

        % Select colour channel of necessary
        if use_greyscale
            imc_stego = im_stego;
        else
            imc_stego = im_stego(:,:,channel);
        end
        
        % Decode
        tic;
        switch current_algorithm
            case 'al_lsb'
                [extracted_msg_bin] = steg_lsb_decode(imc_stego);
            case 'al_dct'
                [extracted_msg_bin] = steg_dct_decode(imc_stego, frequency_coefficients);
            case 'al_zk'
                [extracted_msg_bin, ~, ~] = steg_zk_decode(imc_stego, frequency_coefficients, minimum_distance_decode);
            case 'al_wdct'
                % WDCT only works on frame size of 16
                imc_stego_part = imc_stego(1:floorx(height, 16), 1:floorx(width, 16));
                [extracted_msg_bin] = steg_wdct_decode(imc_stego_part, mode, frequency_coefficients);
            case 'al_fusion'
                [extracted_msg_bin] = steg_fusion_decode(imc_stego, imc, mode);
            case 'al_egypt'
                [im_extracted, ~] = steg_egypt_decode(imc_stego, secret_msg_w, secret_msg_h, key1, key2, mode, block_size, is_binary);
                extracted_msg_bin = binimg2bin(im_extracted, pixel_size, 127);
            otherwise
                error('No such algorithm "%s" exists for decoding.', algorithm);
        end
        decode_time = toc;
        
        % Convert message to string
        extracted_msg_str = bin2str(extracted_msg_bin);

        % Show images
        if use_greyscale
            axes(handles.im_input);
            imshow(uint8(imc), [0 255]);
            axes(handles.im_output);
            imshow(uint8(imc_stego), [0 255]);
        else
            axes(handles.im_input);
            imshow(uint8(im), [0 255]);
            axes(handles.im_output);
            imshow(uint8(im_stego), [0 255]);
        end
        
        % Calculate statistics
        [length_bytes, msg_similarity_py, msg_similarity, im_psnr] = steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin, encode_time, decode_time);
        
        %TODO: Make the float result from this display correctly
        %{
        if strcmp(current_algorithm, 'al_zk')
            length_bytes = bits_written/8;
        end
        %}
        
        % Output
        fprintf('Message: "%s"\n', extracted_msg_str);
        
        % Remove null byte
        extracted_msg_str_cleaned = regexprep(extracted_msg_str, '[\x00-\x1F]', '?');
        
        set(handles.msg_output, 'String', extracted_msg_str_cleaned);
        set(handles.status, 'String', sprintf('Match:%2.2f%% PSNR:%.2fdB Size:%d bytes En-time: %fs De-time: %fs', msg_similarity * 100, im_psnr, length_bytes, encode_time, decode_time));
    end
end
% --- Executes when selected object is changed in panel_algorithm.
function panel_algorithm_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_algorithm 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.figure1, 'current_algorithm', get(eventdata.NewValue, 'Tag'));


% --- Executes when selected object is changed in panel_covermedia.
function panel_covermedia_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_covermedia 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.figure1, 'current_covermedia', get(eventdata.NewValue, 'Tag'));


% --- Executes on selection change in quality.
function quality_Callback(hObject, eventdata, handles)
% hObject    handle to quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns quality contents as cell array
%        contents{get(hObject,'Value')} returns selected item from quality
contents = cellstr(get(hObject,'String'));
quality = contents{get(hObject,'Value')};
setappdata(handles.figure1, 'current_quality', quality);


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


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over quality.
function quality_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function msg_output_Callback(hObject, eventdata, handles)
% hObject    handle to msg_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msg_output as text
%        str2double(get(hObject,'String')) returns contents of msg_output as a double

% --- Executes during object creation, after setting all properties.
function msg_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msg_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
colourspace = contents{get(hObject,'Value')};
setappdata(handles.figure1, 'current_colourspace', colourspace);


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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SetAllToDefaults(handles);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton2.
function pushbutton2_ButtonDownFcn(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in custom_image.
function custom_image_Callback(hObject, eventdata, handles)
% hObject    handle to custom_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Choose file
[filename, filepath] = uigetfile({'*.jpg', 'JPEG'; '*.png', 'PNG'; '*.bmp', 'BMP'; '*.*', 'All Files'}, 'Choose an image');
setappdata(handles.figure1, 'custom_filename', filename);
setappdata(handles.figure1, 'custom_filepath', filepath);

% Set cover media
set(handles.panel_covermedia, 'SelectedObject', handles.cm_custom);
setappdata(handles.figure1, 'current_covermedia', 'cm_custom');
