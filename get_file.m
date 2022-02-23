%% Función que graba un archivo de audio.
% Input: tiempo de grabación (positivo)
% Output: Vector con la información sonora normalizada y la frecuencia de muestreo
function [x,fs] = get_file(time)
    if time > 0
    recObj = audiorecorder; % Creando el objeto de audio

    fs = recObj.SampleRate; % Extrayendo la frecuencia de muestreo del objeto de grabación.

    disp('Comienza la grabación.')
    recordblocking(recObj, time);
    disp('Termina la grabación.');

    x= getaudiodata(recObj); % Extrayendo los datos grabados del elemento de grabación
    x = x./max(x); % Normalización de la señal
    else
        disp('Por favor ingrese un tiempo positivo :)');
    end
end