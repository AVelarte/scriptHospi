clc,clear; close all;
disp("Empieza");
global D
bipolar = false;
% ruta_ini = uigetdir('C:\Users\Antonio\Desktop\DOCTORADO\08_PrimerCurso\Hospital');
ruta_ini = "C:\Users\Antonio\Desktop\DOCTORADO\08_PrimerCurso\Hospital\2021_11\2021-11-22_20-50-28_144";
try 
    ruta = ruta_ini +"\Record Node 102\experiment1\recording1\structure.oebin";
    D = load_open_ephys_binary(ruta,'continuous',1);
catch
    ruta = ruta_ini +"\Record Node 103\experiment1\recording1\structure.oebin";
    D = load_open_ephys_binary(ruta,'continuous',1);
end
longitud_tiempo = size(D.Timestamps);
tiempos = (0:(longitud_tiempo(1)-1)) * (1/D.Header.sample_rate);
canal = 9;
%% Localización de los picos de la señal de trigger
% A la función le pasamos el canal en el que está la señal de trigger, el
% vector de tiempos, y un parámetro booleano que indica el comportamiento de la gráfica
% (true->grafica, false-> no grafica)
% El trigger lo recopilamos en el canal 39
loc_peak = loadTrigger(D.Data(39,:), tiempos, false);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Función para eliminar los 50Hz de la señal
% A la función le pasamos el canal en el que está la señal, el
% vector de tiempos, y dos parámetro booleano que indica el comportamiento de la gráfica
% (el primero para la gráfica temporal de la señal, el segundo para espectro)
datos_notch = grafSignal(canal, tiempos, true, false);  
%% Eliminamos los 50Hz de la excitación y hacemos el stacking de los canales deseados
fig_stackExc = figure('Name',"Stack Señal Excitación");
listaExc = [14, 16];
datos_stack = [];
for i=1:size(listaExc,2)
    datos_notch_Exc = grafSignal(listaExc(i), tiempos, false, false);
    [datos_stack_Exc, tiempos_stack] = makeStack(datos_notch_Exc, tiempos, loc_peak, fig_stackExc);
    datos_stack = [datos_stack; datos_stack_Exc]; 
end
%% Calculamos la media de la señal de excitación
avg_signal_exc = mean(datos_stack);
figure(fig_stackExc);
plot(tiempos_stack, avg_signal_exc, 'LineWidth',3,'DisplayName',"Media");
plotbrowser('on');
%% Recortamos la señal, empieza en el primer pico de trigger detectado y acaba en el último
% [datos_aux, tiempos_aux] = recortarDatos(datos_notch, loc_peak(1), loc_peak(end), tiempos);
datos_stackSign = makeStack(datos_notch, tiempos, loc_peak);
restarSign(datos_stackSign, avg_signal_exc);
