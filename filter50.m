function datos_notch50 = filter50(datos, tiempos) 
    N  = 2;      % Order
    F0 = 50;     % Center frequency
    Q  = 35;     % Q-factor
    Fs = 30000;  % Sampling Frequency

    h = fdesign.notch('N,F0,Q', N, F0, Q, Fs);
    Hd = design(h, 'butter', 'SOSScaleNorm', 'Linf');  
    datos = filter(Hd,datos);
    
%     OTRO FILTRO (resultados muy similares)
%     wo = 50/(30000/2);  
%     bw = wo/35;
%     [b,a] = iirnotch(wo,bw);
    % fvtool(b,a)
%     datos = filter(b,a,datos);

    datos_notch50 = datos;
 
%      fig = figure;
%     fig.WindowState = 'maximized' ;
% %     subplot(2,2,3);
%     % figure;
%     plot(tiempos, datos_notch50);
%     title(' Señal filtro NOTCH 50 ');
% %     xlabel('Tiempo (s)');
% %      ylabel('Tensión (V)');
%      xlabel('Time(s)');
%      ylabel('Voltage (V)');
%     xlim([tiempos(1),tiempos(end)]);
end