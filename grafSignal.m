function datos_notch = grafSignal(canal, tiempos, visSignal, visSpec)
    global D
    datos = D.Data(canal,:);
    datos = datos * 10^(-6);
    %% Graficar señal medida
    if visSignal
        fig = figure('Name',strcat("Original canal ", num2str(canal)));
        fig.WindowState = 'maximized' ;
        plot(tiempos, datos, 'DisplayName','Original')
        title(strcat(" Señal original del canal ", num2str(canal)));
        xlabel('Tiempo (s)')
        xlim([tiempos(1),tiempos(end)])
    end
    %% Graficar espectro de la señal medida
    if visSpec
        fig_esp = figure('Name',"Espectro");
        title("Espectro frecuencial");
        fig_esp.WindowState = 'maximized' ;
        grafEspectroAlt(datos, 1000, fig_esp, 'Raw');
    end
    %% FILTRO NOTCH para señal medida
    datos_notch = filter50(datos, tiempos);
    if visSignal
        figure(fig);
        hold on;
        fig.WindowState = 'maximized' ;
        plot(tiempos, datos_notch, 'DisplayName','Notch');
        lgd =legend;
        lgd.FontSize = 14;
    end 
    %% Graficar espectro de la señal medida tras filtro notch
    if visSpec
        grafEspectroAlt(datos_notch, 1000, fig_esp, 'Notch');
    end
end