clear; clc;
// P205b.sce
s = syslin('c',%s,1);

// Sistema de segundo orden subamortiguado
K = 1; T = 2; z = 0.25; 
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
dt = 0.01; tfin = 80; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,G); 

scf(2); clf(2); 
plot(t,y);
xgrid; xlabel('t'); ylabel('y');

// Alzada
yee = y($)
indexr = find(y>yee,1)
tr = t(indexr)
trt = (%pi-phi)/omega  // Teórico
plot(tr,yee,'ro');

// Pico
[yp,indexp] = max(y)
tp = t(indexp)
tpt = %pi/omega // Teórico
plot(tp,yp,'ro');

// Asentamiento (2%)
indexs = max(find(abs(y-yee) > 0.02*yee));
ts = t(indexs)
tst = 4/alpha // Teórico
ys = y(indexs)
plot(ts,ys,'ro');
