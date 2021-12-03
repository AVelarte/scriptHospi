function done = grafEspectroAlt(datos, rango, fig, label)
    global D
    global fig_esp
    figure(fig);
    fig_esp.WindowState = 'maximized' ;
    X = datos;
    Fs = D.Header.sample_rate;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = size(datos,2);             % Length of signal
    t = (0:L-1)*T;        % Time vector
    Y = fft(X);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    plot(f,P1, 'DisplayName',label) 
    xlim([0,rango]);
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    lgd = legend;
    lgd.FontSize = 14;
    hold on;
end