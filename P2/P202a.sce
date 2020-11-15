clear; clc;
// P202a.sce
s = %s;

K = 1; T = 1;  // Sistema de primer orden
G = syslin('c',K/(T*s+1))  // Función de transferencia
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

dt = 0.01; tfin = 10; t = 0:dt:tfin; // Tiempo
u = 'impuls';  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(2); // clf(2); 
plot(t,y,'b-'); // Respuesta temporal
xgrid; xtitle('Sistema de primer orden - Respuesta a impulso', 't', 'y');
