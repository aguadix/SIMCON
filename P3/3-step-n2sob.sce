// 3-step-n2sob.sce
// Respuesta a escalón
// Sistema de segundo orden sobreamortiguado
clear; clc; s = %s;

K = 1; tau1 = 5; tau2 = 2;
G = K/((tau1*s+1)*(tau2*s+1))
polos = roots(denom(G))

scf(1); clf(1); 
plzr(G); sgrid;

u = 'step';
dt = 0.01; tfin = 10*max(tau1,tau2); t = 0:dt:tfin;
y = csim(u,t,G);

scf(2); clf(2); 
plot(t,y); 
xgrid; xtitle('Sistema de segundo orden sobreamortiguado', 't', 'y');
