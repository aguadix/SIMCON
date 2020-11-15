clear; clc;
// P205.sce
s = %s;

K = 1; T = 1; z = 0.5; // Sistema de segundo orden subamortiguado
alpha = z/T; omega = sqrt(1-z^2)/T; phi = acos(z); 
G = syslin('c',K/(T^2*s^2 + 2*z*T*s + 1))  // Función de transferencia
polos = roots(G.den)

scf(1); clf(1); 
plzr(G); // Gráfico de polos
xtitle('','',''); sgrid;
a1 = gca; 
a1.isoview = 'on';
a1.data_bounds = [-2,-2;2,2];
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
a1.box = 'off';

dt = 0.01; tfin = 30; t = 0:dt:tfin; // Tiempo
u = 'step';  // Entrada
y = csim(u,t,G); // Respuesta temporal

scf(2); //clf(2); 
plot(t,y,'b-');  // Respuesta temporal
xgrid; xtitle('Sistema de segundo orden subamortiguado - Respuesta a escalón', 't', 'y');

// Tiempo de alzada (100%)
yee = y($)
indexr = find(y>yee,1)
tr = t(indexr)
trt = (%pi-phi)/omega  // Teórico
yr = y(indexr)
plot(tr,yr,'ro');

// Tiempo de pico y sobrepaso
[yp,indexp] = max(y)
tp = t(indexp)
tpt = %pi/omega // Teórico
OS = (yp-yee)/yee
plot(tp,yp,'ro');

// Tiempo de asentamiento (2%)
indexs = max(find(abs(y-yee) > 0.02*yee));
ts = t(indexs)
tst = 4/alpha // Teórico
ys = y(indexs)
plot(ts,ys,'ro');
