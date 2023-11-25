clear; clc; 
// P202c.sce
s = syslin('c',%s,1);

K = 1; T = 1;  // Sistema de primer orden
G = K/(T*s+1)  // Función de transferencia

dt = 0.01; tfin = 10; t = 0:dt:tfin; // Tiempo
u = t;  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,K*(t-T),'g-'); // Asíntota oblicua
plot(t,y); // Respuesta temporal
xgrid; xlabel('t'); ylabel('y');
