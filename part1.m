clear all;
close all; 
clc;
format long

% cargamos datos
[xx,fs] = wavread('./Datos de entrenamiento/Blainville_1.wav');
y=xx;
% fs es la frecuencia de muestreo (muestras/segundo)
% xx son los datos de sonido


% construimos el vector de tiempo en segundos
tt = (1:length(xx))'/fs;



%Quitamos el ruido
for i=1:length(tt)
     if abs(xx(i))<0.002
         xx(i)=0;
     end
end



%Partimos de que el valor muestral de mayor
%amplitud es, por clara observación, un click.

%Buscamos las coordenadas de tt y xx del click de mayor amplitud.
z=max(xx);
 for i=1:length(tt)
     if abs(xx(i))==z
         break
     end
 end
 PicoMaximo=xx(i);
 p1=tt(i);

  %Definimos el período de muestreo (segundos transcurridos entre cada
 %muestra).
 T=1/fs;

 %DURACIÓN DEL CLICK.
 %Hallamos la duración del click (96*T equivale a 0.001s, tiempo que no
 %interfiere, tras observar el gráfico en el tiempo, en la variable
 %estudiada).
 for i=1:length(tt)
       if (tt(i)>p1-96*T & tt(i)<p1)
               if xx(i)~=0;
                   break
               end
       end
 end
 
tt1=tt(i-1);

for i=1:length(tt)
        if (tt(i)>p1 & tt(i)<p1+96*T)
               if xx(i)==0;
                   break
               end
        end
end

tt2=tt(i);

DuracionDelClick=abs(tt2-tt1)


%INTERVALO ENTRE CLICKS
 %Eliminamos el reflejo del click mencionado (9600*T equivale a 0.2s,
 %tiempo que no interfiere, tras observar las muestras en el tiempo, en la
 %variable estudiada)(es decir, hacer cero xx desde el click hasta 0.2s a más a la derecha
 %(valor promedio que tarda en reflejarse (y no interfiere con el intervalo
 %entre clicks buscado))).
for i=1:length(tt) 
     if (tt(i)>p1 & tt(i)<p1+9600*T)
         xx(i)=0;
     end
end

%Evaluamos en amplitud las muestras desde el click mencionado hacia la
%derecha, de modo que cuando ésta sea distinta de cero, sabiendo que hemos
%eliminado el ruido, nos encontremos en el click siguiente. Obtenemos así la
%coordenadas de tt del mismo y, restándola con la del primer click,
%obtenemos el intervalo entre clicks buscado.
 for i=1:length(tt)
        if tt(i)>p1
          if xx(i)~=0
            break
          end
        end
 end
 
 p2=tt(i);
 IntervaloEntreClicks=p2-p1
 

%Representamos los datos en el dominio del tiempo
figure(2)
plot(tt,xx)
title('Representación en el tiempo de la Señal');
xlabel('Tiempo tt ( s )');
ylabel('Amplitud xx');


%Frecuencia.
%Eliminamos en el tiempo todo menos un click (el evaluado antes de máxima
%amplitud). Para ello dejamos un intervalo de valor 100*T (100 muestras) a
%un lado y otro de la coordenada tt de dicho click.

for i=1:length(tt)
    if tt(i)<p1-200*T
        y(i)=0;
    elseif tt(i)>p1+200*T
        y(i)=0;
    end
end


%Creamos el vector de frecuencias y hacemos la Transformada de Fourier
%discreta del vector xx.
h=fs./length(y);
f=-fs/2:h:(fs/2)-h;
G=abs(fft(y));


%Quitamos frecuencias superfluas en base a los intervalos teóricos (a
%partir de 40000 aprox.).
 for i=1:length(f)
     if f(i)>40000 
         G(i)=0;
     elseif f(i)<-40000 
         G(i)=0;
     end
 end

%Representamos los datos en el dominio de la frecuencia (Hz).
figure(1)
plot(abs(f),G);
title('Representación en frecuencia del Click');
xlabel('Frecuencia f ( Hz )');
ylabel('G(f)');

%Buscamos la frecuencia con mayor valor en amplitud
k=max(G);
 for i=1:length(f)
     if abs(G(i))==k
         break
     end
 end
 
 fcentral=abs(f(i));
 fminima=fcentral-2000
 fmaxima=fcentral+2000

 
