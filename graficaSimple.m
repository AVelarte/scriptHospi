clc,clear; close all;
% ruta = "C:\Users\Antonio\Desktop\TFM\2_Experimentos_2oCuatri\2021_04_15\2021-04-15_21-15-04_85\Record Node 104\experiment1\recording1\structure.oebin"

ruta_ini = uigetdir('C:\Users\Antonio\Desktop\DOCTORADO\08_PrimerCurso\Hospital');
% ruta = 'C:\Users\Antonio\Desktop\DOCTORADO\08_PrimerCurso\Hospital\2021_10\73_2021-10-25_18-59-17'
try 
    ruta = ruta_ini +"\Record Node 102\experiment1\recording1\structure.oebin";
    D = load_open_ephys_binary(ruta,'continuous',1);
catch
    ruta = ruta_ini +"\Record Node 103\experiment1\recording1\structure.oebin";
    D = load_open_ephys_binary(ruta,'continuous',1);
end
ruta_ini_exc = uigetdir('C:\Users\Antonio\Desktop\DOCTORADO\08_PrimerCurso\Hospital');
try 
    ruta = ruta_ini_exc +"\Record Node 102\experiment1\recording1\structure.oebin";
    D_exc = load_open_ephys_binary(ruta,'continuous',1);
catch
    ruta = ruta_ini_exc +"\Record Node 103\experiment1\recording1\structure.oebin";
    D_exc = load_open_ephys_binary(ruta,'continuous',1);
end

global lista_canales
lista_canales = [2,3,14,15,1,4,13,16,5,6,11,12,7,8,9,10];
% tiempo_inicial = 10.7;
% tiempo_final = 16.5;

longitud_tiempo = size(D.Timestamps);
% global tiempos_aux 
tiempos = 0:1/D.Header.sample_rate:(longitud_tiempo(1)-1)*1/D.Header.sample_rate;
% tiempos_aux = tiempos;
% indice_inicial = find(abs(tiempos-tiempo_inicial) < 1/D.Header.sample_rate);
% indice_final = find(abs(tiempos-tiempo_final) < 1/D.Header.sample_rate);
% if tiempo_final>0
%     tiempos = tiempos(indice_inicial(1):indice_final(1));
% end

longitud_tiempo_exc = size(D_exc.Timestamps);
tiempos_exc = 0:1/D_exc.Header.sample_rate:(longitud_tiempo_exc(1)-1)*1/D_exc.Header.sample_rate;

for canal = 1:16
    datos = D.Data(lista_canales(canal),:);
    datos_exc = D_exc.Data(lista_canales(canal),:);
%     if tiempo_final>0
%         datos = datos(indice_inicial(1):indice_final(1));
%     end
    datos = datos * 10^(-6);
    datos_exc = datos_exc * 10^(-6);
    %datos2 = datos(1:100000);
    %tiempo = D.Timestamps(1:100000);

    % tiempos = (1000/D.Header.sample_rate) * D.Timestamps;
    % tiempos = tiempos - tiempos(1);
%     longitud_tiempo = size(D.Timestamps);
%     tiempos = 0:1/D.Header.sample_rate:(longitud_tiempo(1)-1)*1/D.Header.sample_rate;
    
    fig = figure;
    fig.WindowState = 'maximized' ;
%     subplot(2,2,1);
    % figure;
    title(strcat(' Señal original ', num2str(lista_canales(canal))));
    plot(tiempos, datos)
    xlabel('Tiempo (s)')
    xlim([tiempos(1),tiempos(end)])
    
    fig_exc = figure;
    fig_exc.WindowState = 'maximized' ;
%     subplot(2,2,1);
    % figure;
    title(strcat(' Excitación ', num2str(lista_canales(canal))));
    plot(tiempos_exc, datos_exc)
    xlabel('Tiempo (s)')
    xlim([tiempos_exc(1),tiempos_exc(end)])
    %% ESPECTRO SIN FILTRAR
%     subplot(2,2,2);
    fig_esp = figure('Name',"Espectro");
    title("Espectro frecuencial");
    fig_esp.WindowState = 'maximized' ;
    y = fft(datos);
    %y = y(1:ceil(end/2));
    fs = D.Header.sample_rate;
    f = (0:length(y)-1)*fs/length(y);
    f_raw = f;
    y_raw = y;
    plot(f,abs(y), 'DisplayName','Raw')
    xlabel('Frequency (Hz)')
    xlim([0,1000])
    ylabel('Magnitude')
    title('Magnitude')
    lgd = legend;
    lgd.FontSize = 14;
    hold on
    %% FILTRO NOTCH
    N  = 2;      % Order
    F0 = 50;     % Center frequency
    Q  = 35;     % Q-factor
    Fs = 30000;  % Sampling Frequency

    h = fdesign.notch('N,F0,Q', N, F0, Q, Fs);
    Hd = design(h, 'butter', 'SOSScaleNorm', 'Linf');  
    datos = filter(Hd,datos);
    
%     OTRO FILTRO (resultados muy similares)
    wo = 50/(30000/2);  
    bw = wo/35;
    [b,a] = iirnotch(wo,bw);
    % fvtool(b,a)
%     datos = filter(b,a,datos);

    datos_notch50 = datos;
 
     fig = figure;
    fig.WindowState = 'maximized' ;
%     subplot(2,2,3);
    % figure;
    plot(tiempos, datos_notch50);
    title(' Señal filtro NOTCH 50 ');
%     xlabel('Tiempo (s)');
%      ylabel('Tensión (V)');
     xlabel('Time(s)');
     ylabel('Voltage (V)');
    xlim([tiempos(1),tiempos(end)]);

    %% ESPECTRO TRAS FILTRO NOTCH
%     subplot(2,2,4);
    figure(fig_esp);
    fig_esp.WindowState = 'maximized' ;
    y = fft(datos_notch50);
    %y = y(1:ceil(end/2));
    fs = D.Header.sample_rate;
    f = (0:length(y)-1)*fs/length(y);
    plot(f,abs(y), 'DisplayName','Filtrado 50Hz')
    xlabel('Frequency (Hz)')
    xlim([0,1000])
    ylabel('Magnitude')
    title('Magnitude')
    
    
    
    %%
%    PARA PROBAR UNA VENTANA MÓVIL
%     fig = figure;
%     fig.WindowState = 'maximized' ;
%     mins = 1:length(datos);
%     window = 500;
%     meanspeed = movmean(datos,window);
%     plot(tiempos,datos,tiempos,meanspeed)
%     xlim([tiempos(1),tiempos(end)]);
    %%
    pause
    close all;
end
