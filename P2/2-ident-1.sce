// 2-ident-1.sce
// Identificación de sistemas: obtención de la función de transferencia a partir de datos experimentales
// Entrada: Manipulada, escalón
// Sistema de primer orden
clear; clc; s = %s;

dt = 1; tfin = 60; t = 0:dt:tfin;

u = 2*ones(1,length(t));

scf(1); clf(1); 
subplot(2,1,1); 
plot(t,u); xgrid; xtitle('Entrada', 't', 'u');

yexp = [0	0.571	1.193	1.674	2.104	2.585	2.819	3.161	3.377	3.683	3.881	4.267	4.305	4.793	4.854	4.796	4.979	5.384	5.011	5.46	5.65	5.608	5.555	5.861	5.586	5.772	6.101	5.846	5.766	5.796	6.157	6.173	6.033	6.232	5.888	6.268	6.358	6.405	6.275	6.44	5.918	6.214	6.084	6.331	6.482	5.997	6.4	6.324	5.99	6.441	6.17	6.312	6.173	6.234	6.499	6.432	6.441	6.147	6.395	6.412	6.207];

subplot(2,1,2); 
plot(t,yexp,'ro'); xgrid; xtitle('Salida', 't', 'y');

koptguess = [1 1];
k = koptguess;
G = k(1)/(k(2)*s+1);
ycaloptguess = csim(u,t,G);
plot(t,ycaloptguess,'g-');

function obj = f(k)
    G = k(1)/(k(2)*s+1);
    ycal = csim(u,t,G)
    obj = sum((yexp - ycal).^2)
endfunction

[kopt,objmin,exitflag,output] = fminsearch(f,koptguess)

k = kopt;
G = k(1)/(k(2)*s+1)
ycalopt = csim(u,t,G);
plot(t,ycalopt);
