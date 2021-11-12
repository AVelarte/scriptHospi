function [datos_rec, tiempos_aux] = recortarDatos(datos, tiempo_inicial, tiempo_final, tiempos)
    global D
    indice_inicial = find(abs(tiempos-tiempo_inicial) < 1/D.Header.sample_rate);
    indice_final = find(abs(tiempos-tiempo_final) < 1/D.Header.sample_rate);
    tiempos_aux = tiempos(indice_inicial(1):indice_final(1));
    datos_rec = datos(indice_inicial(1):indice_final(1));
end


