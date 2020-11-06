// 4-freq-n2sob.sce
// Respuesta en frecuencia
// Sistema de segundo orden sobreamortiguado
clear; clc; s = %s;

K = 1; tau1 = 5; tau2 = 2;
G = syslin('c', K/((tau1*s+1)*(tau2*s+1)))

dt = 0.1; tfin = 60; t = 0:dt:tfin;
M = 1; f = 0.1; omega = 2*%pi*f; u = M*sin(omega*t);
y = csim(u,t,G);

scf(1); clf(1); 
plot(t,u,t,y); 
xgrid; xtitle('Sistema de segundo orden sobreamortiguado', 't', 'u(azul), y(verde)');

fmin = 1E-3; fmax = 1E1;

scf(2); clf(2);
bode(G,fmin,fmax)
xtitle('Diagrama de Bode');

scf(3); clf(3);
nyquist(G,fmin,fmax,%f)
xtitle('Diagrama de Nyquist');
