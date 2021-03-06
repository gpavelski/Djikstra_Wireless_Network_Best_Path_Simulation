function varargout = RedesGUI(varargin)
% REDESGUI MATLAB code for RedesGUI.fig
%      REDESGUI, by itself, creates a new REDESGUI or raises the existing
%      singleton*.
%
%      H = REDESGUI returns the handle to a new REDESGUI or the handle to
%      the existing singleton*.
%
%      REDESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REDESGUI.M with the given input arguments.
%
%      REDESGUI('Property','Value',...) creates a new REDESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RedesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RedesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RedesGUI

% Last Modified by GUIDE v2.5 27-Jun-2017 13:24:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RedesGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RedesGUI_OutputFcn, ...
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
end

% --- Executes just before RedesGUI is made visible.
function RedesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to RedesGUI (see VARARGIN)

    % Choose default command line output for RedesGUI
    handles.flag = 0;
    handles.flagSlider = 0;
    setappdata(0, 'Flag', handles.flag);
    setappdata(0, 'Flag2', 0);
    setappdata(0, 'FlagSlider', handles.flagSlider);
    setappdata(0, 'MaxEnlaces',45);
    handles.G = [1 1 1 1];
    c = handles.G;
    setappdata(0, 'block', c);
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
    set(handles.pushbutton1,'enable','off');
    Pb = handles.pushbutton1;
    setappdata(0, 'Pbutton', Pb);
    
    set(handles.uibuttongroup1,'visible','off');
    Bg = handles.uibuttongroup1;
    setappdata(0, 'Bgroup', Bg);
    % UIWAIT makes RedesGUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = RedesGUI_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;

end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    guidata(hObject, handles);
    
    handles.G = getappdata(0,'block');
    handles.uibuttongroup1 = getappdata(0, 'Bgroup');
    handles.numNos = getappdata(0,'NumNos');
    handles.numEnlaces = getappdata(0, 'numEnlaces');
    flagSlider = getappdata(0, 'FlagSlider');

    Bg = handles.uibuttongroup1;
    setappdata(0, 'Bgroup', Bg);
    v=get(handles.uibuttongroup1,'SelectedObject');
    w = get(v, 'String');
    switch w
        case 'N�o'
            handles.G(2) = 1;
        case 'Sim'
            handles.G(2) = 0;
    end
    if handles.G(1) == 3
       handles.G(2) = 0; 
    end
        if flagSlider == 1
            nNos = get(handles.numNos, 'Value');
            nEnlaces = get(handles.numEnlaces, 'Value');
            Redes_Rand_Input(floor(nNos),floor(nEnlaces),handles.G(2),20);
        end

    [msg_1 msg_2] = Redes_sem_Fio(handles.G(1),handles.G(2),handles.G(3), handles.G(4));
         uicontrol('Style', 'text', ...
                  'String', msg_1, ...
                 'Units', 'pixels', ...
                  'Position', [825, 660, 152, 71], ...
                  'BackgroundColor', 'white');
              
         uicontrol('Style', 'text', ...
                 'String', msg_2, ...
                  'Units', 'pixels', ...
                  'Position', [825, 630, 152, 31],...
                  'BackgroundColor', 'white');
end
% --- Executes on selection change in popupmenu1.
function [c] = popupmenu1_Callback(hObject, eventdata, handles)
    % hObject    handle to popupmenu1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popupmenu1

    % Determine the selected data set.
    str = get(hObject, 'String');
    val = get(hObject,'Value');
   
    handles.flag = getappdata(0,'Flag');
    flag = handles.flag;
    flag2 = getappdata(0,'Flag2');
    flagSlider = getappdata(0, 'FlagSlider');
    lmax = getappdata(0, 'MaxEnlaces');
    
    if flag == 1
        flag = 0;
        setappdata(0, 'Flag', flag);
        handles.popupdestino = getappdata(0, 'PopUpDest');
        set(handles.popupdestino, 'Visible', 'off');

        handles.popDestTxt = getappdata(0, 'PopDestTxt');
        set(handles.popDestTxt, 'Visible', 'off');
        
    end
    if flag2 == 1
        flag2 = 0;
        setappdata(0, 'Flag2', flag2);
        set(handles.pushbutton1,'enable','off');
        handles.uibuttongroup1 = getappdata(0, 'Bgroup');
        set(handles.uibuttongroup1,'visible', 'off');
    end
    
    % Set current data to the selected data set.
    switch str{val};
    case 'Grafo 1'
       handles.G(1) = 1;
    case 'Grafo 2'
        handles.G(1) = 2;   
    case 'Grafo 3'
        handles.G(1) = 3;
    case 'Grafo 4'
       handles.G(1) = 4;
    case 'Grafo 5'
        handles.G(1) = 5;   
    case 'Grafo 6'
        handles.G(1) = 6; 
    case 'Grafo Aleat�rio'
        handles.G(1) = 255;
    end
    
    if handles.G(1) == 255
    
    handles.numNosTxt = uicontrol('Style', 'text', ...
              'String', 'Selecione o n�mero de n�s: ', ...
              'Units', 'pixels', ...
              'Position', [380, 340, 145, 21]);

    handles.numNos = uicontrol('Style', 'slider', ...
              'Min', 2, 'Max', 26, 'Value', 10, ...
              'SliderStep', [1/24 , 1],...
              'Units', 'pixels', ...
              'Position', [400, 320, 125, 21], ...
              'Callback', @numNos);
          
    sliderValue = get(handles.numNos,'Value');
    
    
    lmax = getappdata(0,'MaxEnlaces');              
    
    handles.numNosTxt2 = uicontrol('Style', 'text', ...
              'String', sliderValue, ...
              'Units', 'pixels', ...
              'Position', [400, 295, 125, 21]);

    handles.numEnlacesTxt = uicontrol('Style', 'text', ...
              'String', 'Selecione o n�mero de enlaces: ', ...
              'Units', 'pixels', ...
              'Position', [380, 275, 170, 21]);
          
     handles.numEnlaces = uicontrol('Style', 'slider', ...
              'Min', 2, 'Max', lmax, 'Value', 2,...
              'SliderStep', [1/(lmax-2), 1],...
              'Units', 'pixels', ...
              'Position', [400, 245, 125, 21], ...
              'Callback', @numEnlaces);
          
          sliderEnlacesValue = get(handles.numEnlaces, 'Value');
          
          handles.numEnlTxt2 = uicontrol('Style', 'text', ...
              'String', sliderEnlacesValue, ...
              'Units', 'pixels', ...
              'Position', [380, 220, 170, 21]);
          
          setappdata(0, 'numEnlacesTxt',handles.numEnlacesTxt);
          setappdata(0, 'numEnlaces', handles.numEnlaces);
          setappdata(0, 'numEnlacesTxt2',handles.numEnlTxt2);
          setappdata(0, 'NumNos', handles.numNos);
          setappdata(0, 'NumNosTxt', handles.numNosTxt);
          setappdata(0, 'NumNosTxt2', handles.numNosTxt2);
          
          flagSlider = 1;
          setappdata(0, 'FlagSlider', flagSlider);
          

    elseif flagSlider == 1

        set(handles.numNos,'visible','off');
        set(handles.numNosTxt, 'visible', 'off');
        set(handles.numNosTxt2, 'visible', 'off');
        set(handles.numEnlacesTxt, 'visible', 'off');
        set(handles.numEnlTxt2, 'visible', 'off');
        set(handles.numEnlaces,'visible', 'off');
        flagSlider = 0;
        setappdata(0, 'FlagSlider', flagSlider);
    end
    
    handles.G(3) = 1;
    Arquivo = 'Input_Grafo';
    

    Entrada = [Arquivo, num2str(handles.G(1)), '.txt'];
    A = importdata(Entrada); 

    n=1;
    n = max(unique(A.data(:,1:2)));
    if handles.G(1) == 255
        n = 10;
    end
    Alphabet = char('A' + (1:n)-1)';
    nomes = cellstr(Alphabet)';

    str = sprintf('N� %c|', nomes{1:n});
    str(end) = [];

    CString = regexp(str, '#', 'split');
    uicontrol('Style', 'text', ...
              'String', 'Insira o n� de origem: ', ...
              'Units', 'pixels', ...
              'Position', [200, 270, 105, 21], ...
              'Callback', @popuporigem);

    handles.poporigem = uicontrol('Style', 'popupmenu', ...
              'String', str, ...
              'Units', 'pixels', ...
              'Position', [200, 255, 95, 21], ...
              'Callback', @popuporigem);

    setappdata(0, 'PopUpOrig', handles.poporigem);
    % Save the handles structure.
   guidata(hObject,handles)
   drawnow
    
    setappdata(0, 'block', handles.G);
    setappdata(0, 'text', str);
end

function [c] = popuporigem(hObject, eventdata, handles)

    flag = getappdata(0,'Flag');
    flag2 = getappdata(0,'Flag2');
    flagSlider = getappdata(0, 'FlagSlider');
    handles.numNos = getappdata(0, 'NumNos');
    handles.numNosTxt = getappdata(0, 'NumNosTxt');
    handles.numNosTxt2 = getappdata(0, 'NumNosTxt2');
    handles.numEnlacesTxt = getappdata(0, 'numEnlacesTxt');
    handles.numEnlTxt2 = getappdata(0, 'numEnlacesTxt2');
    handles.numEnlaces = getappdata(0, 'numEnlaces');
    handles.poporigem = getappdata(0, 'PopUpOrig');
    

    if flag == 1
       flag = 0;
       handles.popupdestino = getappdata(0, 'PopUpDest');
       handles.popDestTxt = getappdata(0, 'PopDestTxt');
       setappdata(0, 'Flag', flag);
       set(handles.popDestTxt, 'visible','off');
       set(handles.popupdestino, 'visible', 'off');
    end
    
    if flag2 == 1
        flag2 = 0;
        handles.pushbutton1 = getappdata(0, 'Pbutton');
        setappdata(0, 'Flag2', flag2);
        set(handles.pushbutton1,'enable','off');
        handles.uibuttongroup1 = getappdata(0, 'Bgroup');
        set(handles.uibuttongroup1,'visible', 'off');
    end
    
    drawnow
    handles.G = getappdata(0,'block');
    Opt = getappdata(0, 'text');
    
    str2 = get(hObject, 'String');
    val = get(hObject,'Value');
    str = cellstr(str2);
    h = str{val};
    [token remain]= strtok(h, ' ');
    b = strtrim(remain);
    handles.G(3) = double(b) -64;
    handles.G(4) = 1;

    handles.flag = 1;
    setappdata(0,'Flag',handles.flag);
    
    handles.popDestTxt = uicontrol('Style', 'text', ...
              'String', 'Insira o n� de destino: ', ...
              'Units', 'pixels', ...
              'Position', [200, 223, 110, 21]);
          
     handles.popupdestino = uicontrol('Style', 'popupmenu', ...
                  'String', Opt, ...
                  'Units', 'pixels', ...
                  'Position', [200, 200, 95, 21], ...
                  'Callback', @popupdestino);

    % Save the handles structure.
    guidata(hObject,handles);
    setappdata(0, 'block', handles.G);
    setappdata(0, 'PopUpDest', handles.popupdestino);
    setappdata(0, 'PopDestTxt', handles.popDestTxt);
    setappdata(0, 'NumNos', handles.numNos);
    setappdata(0, 'NumNosTxt', handles.numNosTxt);
    setappdata(0, 'NumNosTxt2', handles.numNosTxt2);
    setappdata(0, 'numEnlacesTxt',handles.numEnlacesTxt);
    setappdata(0, 'numEnlacesTxt2',handles.numEnlTxt2);
    setappdata(0, 'numEnlaces', handles.numEnlaces);
    setappdata(0, 'PopUpOrig', handles.poporigem);
    setappdata(0, 'text', str2);
    flag2 = getappdata(0, 'Flag2');
    setappdata(0, 'Flag2', flag2);
    setappdata(0, 'FlagSlider', flagSlider);
    %guidata(hObject,handles)
end

function [c] = popupdestino(hObject, eventdata, handles) 
    handles.G = getappdata(0,'block');
    handles.pushbutton1 = getappdata(0, 'Pbutton');
    handles.uibuttongroup1 = getappdata(0, 'Bgroup');
    handles.numNos = getappdata(0, 'NumNos');
    handles.numNosTxt = getappdata(0, 'NumNosTxt');
    handles.numNosTxt2 = getappdata(0, 'NumNosTxt2');
    handles.numEnlacesTxt = getappdata(0, 'numEnlacesTxt');
    handles.numEnlTxt2 = getappdata(0, 'numEnlacesTxt2');
    handles.numEnlaces = getappdata(0, 'numEnlaces');
    handles.poporigem = getappdata(0, 'PopUpOrig');
    handles.popupdestino = getappdata(0, 'PopUpDest');
    str2 = getappdata(0, 'text');
    val = get(handles.popupdestino, 'Value');
    flagSlider = getappdata(0, 'FlagSlider');
    str = cellstr(str2);
    String = str{val};
    [token remain]= strtok(String, ' ');
    b = strtrim(remain);
    handles.G(4) = double(b) -64;

    if handles.G(1) ~= 3
        Bg = handles.uibuttongroup1;
        setappdata(0, 'Bgroup', Bg);
        set(handles.uibuttongroup1,'visible','on')
    else
        handles.G(2) = 0;
        set(handles.uibuttongroup1,'visible','off')
    end
    guidata(hObject,handles);
    c = handles.G;
    setappdata(0, 'block', c);
    set(handles.pushbutton1,'enable','on')
    Pb = handles.pushbutton1;
    setappdata(0,'Pbutton', Pb);
    
    flag2 = 1;
    setappdata(0,'Flag2',flag2);
    flag = getappdata(0, 'Flag');
    setappdata(0, 'Flag', flag);
    setappdata(0, 'FlagSlider', flagSlider);
    setappdata(0, 'NumNos', handles.numNos);
    setappdata(0, 'NumNosTxt', handles.numNosTxt);
    setappdata(0, 'NumNosTxt2', handles.numNosTxt2);
    setappdata(0, 'numEnlacesTxt',handles.numEnlacesTxt);
    setappdata(0, 'numEnlacesTxt2',handles.numEnlTxt2);
    setappdata(0, 'numEnlaces', handles.numEnlaces);
    setappdata(0, 'PopUpOrig', handles.poporigem);
    setappdata(0,'PopUpDest',handles.popupdestino);
end

function numNos(hObject, eventdata, handles) 
    handles.G = getappdata(0,'block');
    flagSlider = getappdata(0, 'FlagSlider');
    flag = getappdata(0, 'Flag');
    handles.numNos = getappdata(0, 'NumNos');
    sliderValue = get(handles.numNos, 'Value');
    handles.numNosTxt2 = getappdata(0, 'NumNosTxt2');
    handles.poporigem = getappdata(0, 'PopUpOrig');
    handles.popupdestino = getappdata(0,'PopUpDest');
    set(handles.numNosTxt2, 'String', floor(sliderValue));
    n = floor(sliderValue);
    Alphabet = char('A' + (1:n)-1)';
    nomes = cellstr(Alphabet)';

    str = sprintf('N� %c|', nomes{1:n});
    str(end) = [];
    set(handles.poporigem, 'String', str);
    set(handles.poporigem, 'Value', 1);
    handles.G(3) = 1;
    if flag == 1
        set(handles.popupdestino, 'String', str);
        set(handles.popupdestino,'Value', 1);
        setappdata(0,'PopUpDest',handles.popupdestino);
        handles.G(4) = 1;
    end
    handles.numEnlacesTxt= getappdata(0, 'numEnlacesTxt');
    handles.numEnlTxt2 = getappdata(0, 'numEnlacesTxt2');
    handles.numEnlaces = getappdata(0, 'numEnlaces');
    lmax = nchoosek(floor(sliderValue),2); %N�mero m�ximo de enlaces.
    set(handles.numEnlaces,'Max',lmax);
    set(handles.numEnlaces,'Value',lmax);
    setappdata(0, 'block', handles.G);
    
    if lmax ~= 1
        set(handles.numEnlaces, 'SliderStep', [1/(lmax-2),1]);
    else
        set(handles.numEnlaces, 'SliderStep', [1,1]);
    end
    set(handles.numEnlTxt2,'String',lmax);
    setappdata(0,'MaxEnlaces',lmax);
    setappdata(0,'NumNos',handles.numNos);
    setappdata(0,'NumNosTxt2',handles.numNosTxt2);
    setappdata(0,'numEnlacesTxt', handles.numEnlacesTxt);
    setappdata(0,'numEnlaces',handles.numEnlaces);
    setappdata(0,'numEnlacesTxt2',handles.numEnlTxt2);
    setappdata(0, 'FlagSlider', flagSlider);
    setappdata(0, 'PopUpOrig', handles.poporigem);
    setappdata(0, 'block', handles.G);

    
end

function numEnlaces(hObject, eventdata, handles) 
    handles.G = getappdata(0,'block');
    flagSlider = getappdata(0, 'FlagSlider');
    handles.numNos = getappdata(0, 'NumNos');
    handles.numNosTxt2 = getappdata(0, 'NumNosTxt2');
    handles.numEnlacesTxt= getappdata(0, 'numEnlacesTxt');
    handles.numEnlaces = getappdata(0, 'numEnlaces');
    handles.numEnlTxt2 = getappdata(0, 'numEnlacesTxt2');
    handles.poporigem = getappdata(0, 'PopUpOrig');
    handles.popupdestino = getappdata(0,'PopUpDest');
    sliderEnlaces = get(handles.numEnlaces, 'Value');
    setappdata(0,'SliderEnlaces', sliderEnlaces);
    set(handles.numEnlTxt2, 'String', floor(sliderEnlaces));
    setappdata(0,'numEnlacesTxt', handles.numEnlacesTxt);
    setappdata(0,'numEnlaces',handles.numEnlaces);
    setappdata(0,'numEnlacesTxt2',handles.numEnlTxt2);
    setappdata(0, 'FlagSlider', flagSlider);
    setappdata(0, 'NumNos', handles.numNos);
    setappdata(0, 'PopUpOrig', handles.poporigem);
    setappdata(0,'PopUpDest',handles.popupdestino);
    setappdata(0,'block', handles.G);
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end
