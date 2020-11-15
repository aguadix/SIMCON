clear; clc;
// P205.sce
s = %s;

K = 1; T = 1;  // Sistema de segundo orden críticamente amortiguado
G = syslin('c',K/(T*s+1)^2)  // Función de transferencia
polos = roots(G.den)

scf(1); clf(1); 
plzr(G); // Gráfico de polos
xtitle('','','');
a1 = gca; 
a1.isoview = 'on';
a1.data_bounds = [-2,-2;2,2];
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
a1.box = 'off';

dt = 0.01; tfin = 30; t = 0:dt:tfin; // Tiempo
u = 'step';  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(2); //clf(2); 
plot(t,y,'b-'); // Respuesta temporal
plot(T,y(t==T),'bo');  // Respuesta t=T
plot(2*T,y(t==2*T),'bo');  // Respuesta t=2T
plot(3*T,y(t==3*T),'bo');  // Respuesta t=3T
plot(4*T,y(t==4*T),'bo');  // Respuesta t=4T
xgrid; xtitle('Sistema de segundo orden críticamente amortiguado - Respuesta a escalón', 't', 'y');
