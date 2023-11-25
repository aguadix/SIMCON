clear; clc; 
// P202b.sce
s = syslin('c',%s,1);

K = 1; T = 1;  // Sistema de primer orden
G = K/(T*s+1)  // Función de transferencia

dt = 0.01; tfin = 10; t = 0:dt:tfin; // Tiempo
u = 'step';  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,y); // Respuesta temporal
for n = 1:4
  plot(n*T,y(t==n*T),'ro');  // Respuesta t=n*T
end
xgrid; xlabel('t'); ylabel('y');
