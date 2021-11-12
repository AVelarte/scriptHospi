function done = grafEspectro(datos, rango, fig, label)
    global D
    global fig_esp
    figure(fig);
%     fig_esp = figure('Name',"Espectro");
%     title("Espectro frecuencial");
    fig_esp.WindowState = 'maximized' ;
    y = fft(datos);
    %y = y(1:ceil(end/2));
    fs = D.Header.sample_rate;
    f = (0:length(y)-1)*fs/length(y);
%     f_raw = f;
%     y_raw = y;
    plot(f,abs(y), 'DisplayName',label)
    xlabel('Frequency (Hz)')
    xlim([0,rango])
    ylabel('Magnitude')
    title('Magnitude')
    lgd = legend;
    lgd.FontSize = 14;
    hold on;
end