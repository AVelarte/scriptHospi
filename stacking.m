function [datos_stack_i, datos_stack_p] = stacking(datos, tiempos, loc_peak, bipolar)
    global PrimerPico   
    mayorLong = 0;
%     figure;
%     if bipolar
%         for j=1:2
%             numCanales = 0;
%             mayorLong = 0;
%             for i=PrimerPico:2:(size(loc_peak,2)-1)
%                 [datos_aux, tiempos_aux] = recortarDatos(datos, loc_peak(i), loc_peak(i+1), tiempos);
%                 if size(datos_aux,2)> mayorLong
%                     mayorLong = size(datos_aux,2);
%                 end
%                 numCanales = numCanales + 1;
%             end
%             M_stack = zeros(numCanales,mayorLong);
%             for i=PrimerPico:2:(size(loc_peak,2)-1)
%                 [datos_aux, tiempos_aux] = recortarDatos(datos, loc_peak(i), loc_peak(i+1), tiempos);
%                 M_stack(i-PrimerPico+1,1:numel(datos_aux)) = datos_aux; 
%         %         hold on;
%         %         plot(datos_aux)
%             end
%         end
%         
%         
%     else



        for i=PrimerPico:(size(loc_peak,2)-1)
            [datos_aux, tiempos_aux] = recortarDatos(datos, loc_peak(i), loc_peak(i+1), tiempos);
            if size(datos_aux,2)> mayorLong
                mayorLong = size(datos_aux,2);
            end
        end
        M_stack = zeros(size(loc_peak,2)-PrimerPico,mayorLong);
        for i=PrimerPico:(size(loc_peak,2)-1)
            [datos_aux, tiempos_aux] = recortarDatos(datos, loc_peak(i), loc_peak(i+1), tiempos);
            M_stack(i-PrimerPico+1,1:numel(datos_aux)) = datos_aux; 
    %         hold on;
    %         plot(datos_aux)
        end  
        datos_stack_i = M_stack;
        datos_stack_p = M_stack;
        
        
        if bipolar
            for j=0:1
                M_aux = [];
                for i=1+j:2:size(M_stack,1)
                    M_aux = [M_aux;M_stack(i,:)];
                end
                if j==0
                    datos_stack_i = M_aux;
                else
                    datos_stack_p = M_aux;
                end
            end
        end
%     end
end

