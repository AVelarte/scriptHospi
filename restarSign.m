function done = restarSign(datosSignal, datosExc)
    global D
    signal_sub =[];
    for i=1:size(datosSignal,1)
       subtraction = datosSignal(i,:) - datosExc;
       signal_sub = [signal_sub, subtraction];
    end
    figure();
    title("Substracción");
    tiempo_sub = (0:(size(signal_sub,2)-1)) * (1/D.Header.sample_rate);
    plot(tiempo_sub, signal_sub);
    xlabel('Tiempo (s)');
    xlim([tiempo_sub(1),tiempo_sub(end)]);
end