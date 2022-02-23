%% Función principal para la ventana rectangular
% Input: vector con información sonora x, frecuencia fs, tipo de obtención
% de audio (grabado o importado) type, vector con valores de amplificación
% amps.
% Output: transformada de Fourier del archivo original Fxs, vector de
% frecuencias f, audio modificado y, transformada de Fourier del audio
% modificado new_Fxs
function [Fxs,f,y,new_Fxs] = rectangular_window(x,fs,type,amps)
    Fx = fft(x); % Transformada de Fourier
    Fxs = fftshift(Fx); % Corrimiento de la transformada 
    n = length(x);
    f = (-n/2:n/2-1)*fs/n; % Creación del vector de Frecuencias
    bands = [31, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000, 24000]; % Bandas (punto medio)
    pos_zero = floor((n/2))+1; % Posición dentro del vector para la frecuencia cero
    new_Fxs = zeros(n,1); % Vector de la nueva transformada
    inicial = 0; % Frecuencia inicial
    if type == 1 % Tipo 1 = importado
        k = 10;
    else
        k = 7; % Tipo 2 = grabación
    end
    for m = 1:k
        v = zeros(1,length(x)); % Creación de un vector para la ventana
        final = floor((bands(m) + bands(m+1))/2); % Frecuencia final
        i = pos_zero + floor(inicial/(f(2)-f(1))); % Posición de la frecuencia inicial
        j = pos_zero + floor(final/(f(2)-f(1))); % Posición de la frecuencia final
        ventana = rectwin(j-i+1); % Creación de la ventana rectangular
        d_i = abs(i - pos_zero);
        d_j = abs(j - pos_zero);
        minus_i = abs(i - 2*d_i); % Posición del equivalente a inicial en la parte negativa
        minus_j = abs(j - 2*d_j); % Posición del equivalente a final en la parte negativa
        v(i:j) = ventana;
        v(minus_j: minus_i) = ventana; % Se incluye dentro del vector las ventanas
        new_Fxs = new_Fxs + (amps(m).*(v').*Fxs); % Se multiplica por su factor correspondiente y se suma
        inicial = final + f(2) - f(1); % Nueva frecuencia inicial
    end
    if k == 7 % Última banda (especial para una grabación)
       v = zeros(1,length(x)); % Creación de un vector para la ventana
       ventana_1 = rectwin(minus_j); 
       ventana_2 = rectwin(length(x) - j + 1); % Creación de las ventanas rectangulares
       v(1:minus_j) = ventana_1;
       v(j:length(x)) = ventana_2; % Se incluye dentro del vector las ventanas
       new_Fxs = new_Fxs + (amps(8).*(v').*Fxs); % Se multiplica por su factor correspondiente y se suma
    end
    Fx2 = ifftshift(new_Fxs); % Deshace el corrimiento
    y = real(ifft(Fx2)); % Transformada inversa
    y = y./max(y);  % Normalización de la señal
end