clear; clc;
// P204a.sce
s = syslin('c',%s,1);

// Sistema de segundo orden críticamente amortiguado
K = 1; T = 1;  
G = K/(T*s+1)^2  

// Polos y ceros
polos = roots(G.den)
scf(1); clf(1); 
plzr(G);
xtitle('','','');
a1 = gca; 
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
a1.data_bounds = [-2,-2;2,2];
a1.isoview = 'on';
a1.box = 'off';

// Respuesta temporal
dt = 0.01; tfin = 30; t = 0:dt:tfin;
u = 'impuls';
y = csim(u,t,G);  

scf(2); clf(2);
plot(t,y);
xgrid; xlabel('t'); ylabel('y');

// Pico
[yp,indexp] = max(y)
tp = t(indexp)
tpt = T  // Teórico
plot(tp,yp,'ro');

// Punto de inflexión
dydt = diff(y)/dt;
[dydtmax,indexI] = min(dydt)
tI = t(indexI)
tIt = 2*T  // Teórico
yI = y(indexI)
plot(tI,yI,'ro');
