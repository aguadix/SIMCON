// 2-ident-3.sce
// Identificación de sistemas: obtención de la función de transferencia a partir de datos experimentales
// Entrada: Manipulada, pseudorandom binary sequence (prbs_a)
// Sistema de segundo orden con numerador dinámico
clear; clc; s = %s;

dt = 0.1; tfin = 5; t = 0:dt:tfin;

u = [-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	1	1	1	1	-1	-1	-1	-1	1	1	1	-1	1	1	-1	-1	-1	-1	-1	-1	-1	-1	1	1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	1	1	1];

scf(1); clf(1);
subplot(2,1,1);  
plot(t,u); xgrid; xtitle('Entrada', 't', 'u');

yexp = [0	-0.214	-0.444	-0.644	-0.809	-0.783	-1.13	-1.155	-1.021	-1.066	-1.451	-1.337	-1.327	-0.993	-0.51	-0.246	-0.259	-0.401	-0.756	-0.993	-0.906	-0.361	-0.14	-0.218	-0.222	0.045	0	-0.314	-0.542	-0.813	-1.05	-1.118	-1.064	-1.436	-1.026	-0.64	-0.68	-0.786	-0.868	-1.341	-1.424	-1.666	-1.26	-1.314	-1.766	-1.595	-1.869	-1.605	-1.684	-1.162	-0.972];

subplot(2,1,2); 
plot(t,yexp,'ro'); xgrid; xtitle('Salida', 't', 'y');

koptguess = [1 1 1 1];
k = koptguess;
G = (k(1)*s+k(2))/(k(3)*s^2+k(4)*s+1);
ycaloptguess = csim(u,t,G);
plot(t,ycaloptguess,'g-');

function obj = f(k)
    G = (k(1)*s+k(2))/(k(3)*s^2+k(4)*s+1);
    ycal = csim(u,t,G)
    obj = sum((yexp - ycal).^2)
endfunction

[kopt,objmin,exitflag,output] = fminsearch(f,koptguess)

k = kopt;
G = (k(1)*s+k(2))/(k(3)*s^2+k(4)*s+1)
ycalopt = csim(u,t,G);
plot(t,ycalopt);
