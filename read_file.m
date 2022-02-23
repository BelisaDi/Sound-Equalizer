%% Función que lee un archivo de audio.
% Input: nombre del archivo, incluida la extensión
% Output: Vector con la información sonora normalizada y la frecuencia de muestreo
function [x,fs] = read_file(filename)
    [x,fs] = audioread(filename);
    x = x./max(x); % Normalización de la señal
end
