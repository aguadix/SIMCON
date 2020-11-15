clear; clc;
// P204.sce
s = %s;

K = 1; T1 = 5; T2 = 1; // Sistema de segundo orden sobreamortiguado
G = syslin('c',K/((T1*s+1)*(T2*s+1))) // Función de transferencia
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

dt = 0.01; tfin = 30; t = 0:dt:tfin;  // Tiempo
u = 'step';  // Entrada
y = csim(u,t,G);  // Respuesta tempora

scf(2); //clf(2); 
plot(t,y,'b-'); // Respuesta temporal
xgrid; xtitle('Sistema de segundo orden sobreamortiguado - Respuesta a escalón', 't', 'y');

// Punto de inflexión
for i = 1:length(t)-2
  d2y(i) = y(i+2)-2*y(i+1)+y(i); // Segundo diferencial
end
indexI = find(d2y<0,1);
tI = t(indexI)
tIt = log(T1/T2)/(1/T2-1/T1)  // Teórico
plot(tI,y(t==tI),'bo');
