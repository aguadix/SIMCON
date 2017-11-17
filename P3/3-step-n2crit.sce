// 3-step-n2crit.sce
// Respuesta a escalón
// Sistema de segundo orden críticamente amortiguado
clear; clc; s = %s;

K = 1; tau = 10;
G = K/(tau*s+1)^2
polos = roots(denom(G))

scf(1); clf(1); 
plzr(G); sgrid;

u = 'step';
dt = 0.01; tfin = 10*tau; t = 0:dt:tfin;
y = csim(u,t,G);

scf(2); clf(2); 
plot(t,y); 
xgrid; xtitle('Sistema de segundo orden críticamente amortiguado', 't', 'y');
