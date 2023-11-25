clear; clc; 
// P205.sce
s = syslin('c',%s,1);

K = 1; T = 1;  // Sistema de segundo orden críticamente amortiguado
G = K/(T*s+1)^2  // Función de transferencia
polos = roots(G.den)

scf(1); clf(1); 
plzr(G); // Gráfico de polos
xtitle('','','');
a1 = gca; 
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
a1.data_bounds = [-2,-2;2,2];
a1.isoview = 'on';
a1.box = 'off';

dt = 0.01; tfin = 30; t = 0:dt:tfin; // Tiempo
u = 'step';  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(2); clf(2); 
plot(t,y); // Respuesta temporal
for n = 1:4
  plot(n*T,y(t==n*T),'ro');  // Respuesta t=n*T
end
xgrid; xlabel('t'); ylabel('y');
