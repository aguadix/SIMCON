// 4-freq-n2sub.sce
// Respuesta en frecuencia
// Sistema de segundo orden subamortiguado
clear; clc; s = %s;

K = 1; tau = 2; zeta = 0.1;
G = syslin('c',K/(tau^2*s^2+2*tau*zeta*s+1))

dt = 0.1; tfin = 150; t = 0:dt:tfin;
M = 1; f = 0.08; omega = 2*%pi*f; u = M*sin(omega*t);
y = csim(u,t,G);

scf(1); clf(1); 
plot(t,u,t,y); 
xgrid; xtitle('Sistema de segundo orden subamortiguado', 't', 'u(azul), y(verde)');

fmin = 1E-3; fmax = 1E1;

scf(2); clf(2);
bode(G,fmin,fmax)
xtitle('Diagrama de Bode');

fr = freson(G)
[dBmax,phir] = dbphi(repfreq(G,fr))
scf(3); clf(3); 
gainplot(G)
plot(fr,dBmax,'ro')

scf(4); clf(4);
nyquist(G,fmin,fmax,%f)
xtitle('Diagrama de Nyquist');
