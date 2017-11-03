// 2-ident-2.sce
// Identificación de sistemas: obtención de la función de transferencia a partir de datos experimentales
// Entrada: Manipulada, escalón
// Sistema de segundo orden subamortiguado
clear; clc; s = %s;

dt = 1; tfin = 30; t = 0:dt:tfin;

u = -1*ones(1,length(t));

scf(1); clf(1); 
subplot(2,1,1); 
plot(t,u); xgrid; xtitle('Entrada', 't', 'u');

yexp = [0.00	1.27	3.85	6.13	7.21	7.09	6.27	5.37	4.82	4.73	4.95	5.28	5.53	5.62	5.57	5.46	5.36	5.31	5.31	5.34	5.38	5.41	5.41	5.40	5.39	5.38	5.37	5.38	5.38	5.38	5.39];

subplot(2,1,2); 
plot(t,yexp,'ro'); xgrid; xtitle('Salida', 't', 'y');

koptguess = [1 1 1];
k = koptguess;
G = syslin('c', k(1)/(k(2)^2*s^2+2*k(2)*k(3)*s+1));
ycaloptguess = csim(u,t,G);
plot(t,ycaloptguess,'g-');

function obj = f(k)
    G = syslin('c', k(1)/(k(2)^2*s^2+2*k(2)*k(3)*s+1))
    ycal = csim(u,t,G)
    obj = sum((yexp - ycal).^2)
endfunction

[kopt,objmin,exitflag,output] = fminsearch(f,koptguess)

k = kopt;
G = syslin('c', k(1)/(k(2)^2*s^2+2*k(2)*k(3)*s+1))
ycalopt = csim(u,t,G);
plot(t,ycalopt);
