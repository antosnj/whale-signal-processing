clear all;
close all; 
clc;
format long

% cargamos datos
[xx,fs] = wavread('./Datos de test/test_1.wav');
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


%INTERVALO ENTRE CLICKS
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

DuracionDelClick=abs(tt2-tt1);

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
 IntervaloEntreClicks=p2-p1;
 

%Frecuencia.

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


%Buscamos la frecuencia con mayor valor en amplitud
k=max(G);
 for i=1:length(f)
     if abs(G(i))==k
         break
     end
 end
 
 fcentral=abs(f(i));
 fminima=fcentral-6000;
 fmaxima=fcentral+6000;

 
 
 %Si cumplen las características teóricas de alguna especie (con 
 %márgenes de error por cuestión de aproximaciones experimentales),se muestra por
 %pantalla de qué especie se trata el conjunto de clicks analizados (Ejercicio 2).

if (DuracionDelClick>0.000100 & DuracionDelClick<0.000300)
 if (IntervaloEntreClicks>0.2 & IntervaloEntreClicks<0.4)
  disp('La especie analizada es Blainville');
   end
end 

if (DuracionDelClick>0.000200 & DuracionDelClick<0.000300)
 if (IntervaloEntreClicks>0.4 & IntervaloEntreClicks<0.59)
    disp('La especie analizada es Calderón Tropical');
 end
end 

if (DuracionDelClick>0 & DuracionDelClick<0.000150)
 if (IntervaloEntreClicks>0.4 & IntervaloEntreClicks<0.7)
 disp('La especie analizada es Calderón Gris');
 end
end 



