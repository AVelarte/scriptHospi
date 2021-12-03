function ix_picos = loadTrigger(datos, tiempos, visualizar)
    global D    
    datos = datos * 10^(-6);
    if visualizar
        fig = figure('Name',"Trigger");
        fig.WindowState = 'maximized' ;
        plot(tiempos, datos, 'DisplayName','Trigger')
        title(" Señal de trigger");
        xlabel('Tiempo (s)')
        xlim([tiempos(1),tiempos(end)]) 
    end
    
%     fig_peaks.WindowState = 'maximized' ;
%     findpeaks(datos, tiempos, 'MinPeakHeight', -0.025,  'MinPeakDistance',0.5)
%     [picos,loc_peak]= findpeaks(datos, tiempos, 'MinPeakHeight', -0.025,  'MinPeakDistance',0.5);
    dy = gradient(D.Data(39,:), mean(diff(tiempos))); 
    [dypks,ix] = findpeaks(dy, 'MinPeakDistance',20, 'MinPeakHeight',1E+7);
    ix_picos = ix/D.Header.sample_rate;
    if visualizar
%         fig_peaks = figure('Name',"Peaks Trigger");
%         findpeaks(dy, 'MinPeakDistance',20, 'MinPeakHeight',1E+7)
        hold on;
        plot(tiempos(ix), datos(ix), '*')
    end 
end