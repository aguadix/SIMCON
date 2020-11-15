clear; clc;
// P205.sce
s = %s;

K = 1; Tn = 8; T1 = 4; T2 = 1; // Sistema de segundo orden subamortiguado
G = syslin('c',K*(Tn*s+1)/((T1*s+1)*(T2*s+1)))
polos = roots(G.den)
ceros = roots(G.num)

scf(1); clf(1); 
plzr(G); // Gráfico de polos y ceros
xtitle('','','');
a1 = gca; 
a1.isoview = 'on';
a1.data_bounds = [-2,-2;2,2];
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
a1.box = 'off';

dt = 0.01; tfin = 20; t = 0:dt:tfin;  // Tiempo
u = 'step';  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(2); //clf(2); 
plot(t,y,'b-'); // Respuesta temporal
xgrid; xtitle('Sistema de segundo orden con numerador dinámico - Respuesta a escalón', 't', 'y');

// Máximo
[yp,indexp] = max(y)
tp = t(indexp)
plot(tp,yp,'ro');
tpt = log((1-Tn/T2)/(1-Tn/T1))/(1/T2-1/T1) // Teórico
