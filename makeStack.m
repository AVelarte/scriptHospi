function [datos_stack, tiempos_stack] = makeStack(datos, tiempos, loc_peak, nomFig)
        global D
        if ~exist('nomFig','var')
              nomFig = false;
        end
        mayorLong = 0;
        for i=1:(size(loc_peak,2)-1)
            [datos_aux, tiempos_aux] = recortarDatos(datos, loc_peak(i), loc_peak(i+1), tiempos);
            if size(datos_aux,2)> mayorLong
                mayorLong = size(datos_aux,2);
            end
        end
        M_stack = zeros(size(loc_peak,2)-1,mayorLong);
        for i=1:(size(loc_peak,2)-1)
            [datos_aux, tiempos_aux] = recortarDatos(datos, loc_peak(i), loc_peak(i+1), tiempos);
            M_stack(i,1:numel(datos_aux)) = datos_aux; 
    %         hold on;
    %         plot(datos_aux)
        end  
        datos_stack = M_stack;
        tiempos_stack = (0:(size(datos_stack,2)-1)) * (1/D.Header.sample_rate);
        if nomFig ~= false
            figure(nomFig);
            for i=1:size(datos_stack,1)
                hold on;
                plot(tiempos_stack, datos_stack(i,:))
                xlabel('Tiempo (s)');
                xlim([tiempos_stack(1),tiempos_stack(end)]);
                legend;
            end
        end
end

