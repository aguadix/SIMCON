clear; clc;
// P206.sce
s = syslin('c',%s,1);

// Sistema de segundo orden subamortiguado
K = 1; T = 1; z = 0.2; 
alpha = z/T, omega = sqrt(1-z^2)/T, phi = acos(z) 
G = K/(T^2*s^2 + 2*z*T*s + 1)

// Polos y ceros
polos = roots(G.den)
scf(1); clf(1); 
plzr(G);
xtitle('','',''); sgrid;
a1 = gca; 
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
a1.data_bounds = [-2,-2;2,2];
a1.isoview = 'on';
a1.box = 'off';

// Respuesta temporal
dt = 0.01; tfin = 40; t = 0:dt:tfin;
u = 'impuls';
y = csim(u,t,G); 

scf(2); clf(2); 
plot(t,y);
xgrid; xlabel('t'); ylabel('y');

// Pico
[yp,indexp] = max(y)
tp = t(indexp)
tpt = phi/omega // Teórico
plot(tp,yp,'ro');
