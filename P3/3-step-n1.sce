// 3-step-n1.sce
// Respuesta a escalón
// Sistema de primer orden
clear; clc; s = %s;

K = 3; tau = 2;
G = syslin('c',K/(tau*s+1))
polos = roots(denom(G))

scf(1); clf(1); 
plzr(G); sgrid;

u = 'step';
dt = 0.01; tfin = 5*tau; t = 0:dt:tfin;
y = csim(u,t,G);

scf(2); clf(2); 
plot(t,y); 
xgrid; xtitle('Sistema de primer orden', 't', 'y');
