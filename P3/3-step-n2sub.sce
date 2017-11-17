// 3-step-n2sub.sce
// Respuesta a escalón
// Sistema de segundo orden subamortiguado
clear; clc; s = %s;

K = 1; tau = 5; zeta = 0.3;
G = K/(tau^2*s^2 + 2*tau*zeta*s + 1)
polos = roots(denom(G))

scf(1); clf(1); 
plzr(G); sgrid;

u = 'step';
dt = 0.01; tfin = 8*tau/zeta; t = 0:dt:tfin;
y = csim(u,t,G);

scf(2); clf(2); 
plot(t,y);
xgrid; xtitle('Sistema de segundo orden subamortiguado', 't', 'y');

// Tiempo de alzada (100%)
yee = y($)
index1 = find(y>yee,1)
tr = t(index1)
yr = y(index1)
plot(tr,yr,'ro');

// Tiempo de pico y sobrepaso
[ymax,index2] = max(y)
tp = t(index2)
OS = (ymax-yee)/yee
plot(tp,ymax,'ro');

// Tiempo de asentamiento (2%)
index3 = max(find(abs(y-yee) > 0.02*yee));
ts = t(index3)
ys = y(index3)
plot(ts,ys,'ro');
