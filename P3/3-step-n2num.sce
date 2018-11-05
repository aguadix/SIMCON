// 3-step-n2num.sce
// Respuesta a escalón
// Sistema de segundo orden con numerador dinámico
clear; clc; s = %s;

K = 1; taun = 8; tau1 = 4; tau2 = 1;
G = syslin('c',K*(taun*s+1)/((tau1*s+1)*(tau2*s+1)))
polos = roots(denom(G))

scf(1); clf(1); 
plzr(G); sgrid;

u = 'step';
dt = 0.01; tfin = 10*max(tau1,tau2); t = 0:dt:tfin;
y = csim(u,t,G);

scf(2); clf(2); 
plot(t,y); 
xgrid; xtitle('Sistema de segundo orden con numerador dinámico', 't', 'y');