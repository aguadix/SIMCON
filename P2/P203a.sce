clear; clc; 
// P203a.sce
s = syslin('c',%s,1);

// Sistema de segundo orden sobreamortiguado
K = 1; T1 = 5; T2 = 1; 
G = K/((T1*s+1)*(T2*s+1))

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
tpt = log(T2/T1)/(1/T1-1/T2)  // Teórico
plot(tp,yp,'ro');

