clear; clc;
// P202b.sce
s = %s;

K = 1; T = 1;  // Sistema de primer orden
G = syslin('c',K/(T*s+1))  // Función de transferencia

dt = 0.01; tfin = 10; t = 0:dt:tfin; // Tiempo
u = 'step';  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); // clf(1); 
plot(t,y,'b-'); // Respuesta temporal
for n = 1:4
  plot(n*T,y(t==n*T),'bo');  // Respuesta t=n*T
end
xgrid; xtitle('Sistema de primer orden - Respuesta a escalón', 't', 'y');

