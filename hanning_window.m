%% Función principal para la ventana de Hanning
% Input: vector con información sonora x, frecuencia fs, tipo de obtención
% de audio (grabado o importado) type, vector con valores de amplificación
% amps.
% Output: transformada de Fourier del archivo original Fxs, vector de
% frecuencias f, audio modificado y, transformada de Fourier del audio
% modificado new_Fxs
function [Fxs,f,y,new_Fxs] = hanning_window(x,fs,type,amps)
    Fx = fft(x); % Transformada de Fourier
    Fxs = fftshift(Fx); % Corrimiento de la transformada 
    n = length(x);
    f = (-n/2:n/2-1)*fs/n; % Creación del vector de Frecuencias
    endpoints = [0, 23, 70, 140, 281, 563, 1125, 2250, 4500, 9000, 14000, 20000]; %Extremos de las bandas
    pos_zero = floor((n/2))+1; % Posición dentro del vector para la frecuencia cero
    new_Fxs = zeros(n,1); % Vector de la nueva transformada
    if type == 1 % Tipo 1 = importado
        k = 10;
    else
        k = 6; % Tipo 2 = grabación
    end
    for m = 1:k
        v = zeros(1,length(x)); % Creación de un vector para la ventana
        inicial = endpoints(m); % Frecuencia inicial
        final = endpoints(m+2); % Frecuencia final
        i = pos_zero + floor(inicial/(f(2)-f(1))); % Posición de la frecuencia inicial
        j = pos_zero + floor(final/(f(2)-f(1))); % Posición de la frecuencia final
        ventana = hanning(j-i+1); % Creación de la ventana de Hanning
        d_i = abs(i - pos_zero);
        d_j = abs(j - pos_zero);
        minus_i = abs(i - 2*d_i); % Posición del equivalente a inicial en la parte negativa
        minus_j = abs(j - 2*d_j); % Posición del equivalente a final en la parte negativa
        v(i:j) = ventana;
        v(minus_j: minus_i) = ventana; % Se incluye dentro del vector las ventanas
        new_Fxs = new_Fxs + (amps(m).*(v').*Fxs); % Se multiplica por su factor correspondiente y se suma
    end
    if k == 6 % Últimas dos bandas (especial para una grabación) 
        v = zeros(1,length(x)); % Creación de un vector para la ventana
        inicial = endpoints(k+1); % Frecuencia inicial
        final = 3500; % Frecuencia final 
        i = pos_zero + floor(inicial/(f(2)-f(1))); % Posición de la frecuencia inicial
        j = pos_zero + floor(final/(f(2)-f(1))); % Posición de la frecuencia final
        ventana = hanning(j-i+1); % Creación de la ventana de Hanning
        d_i = i - pos_zero;
        d_j = j - pos_zero;
        minus_i = abs(i - 2*d_i); % Posición del equivalente a inicial en la parte negativa
        minus_j = abs(j - 2*d_j); % Posición del equivalente a final en la parte negativa
        v(i:j) = ventana;
        v(minus_j: minus_i) = ventana; % Se incluye dentro del vector las ventanas
        new_Fxs = new_Fxs + (amps(k+1).*(v').*Fxs); % Se multiplica por su factor correspondiente y se suma
        
        % Última ventana (toma las posiciones restantes)
        v = zeros(1,length(x)); 
        ventana_1 = hanning(minus_j);
        ventana_2 = hanning(length(x) - j + 1);
        v(1:minus_j) = ventana_1;
        v(j:length(x)) = ventana_2;
        new_Fxs = new_Fxs + (amps(k+2).*(v').*Fxs);
    end
    Fx2 = ifftshift(new_Fxs); % Deshace el corrimiento
    y = real(ifft(Fx2)); % Transformada inversa
    y = y./max(y);  % Normalización de la señal
end