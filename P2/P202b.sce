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
plot(T,y(t==T),'bo');  // Respuesta t=T
plot(2*T,y(t==2*T),'bo');  // Respuesta t=2T
plot(3*T,y(t==3*T),'bo');  // Respuesta t=3T
plot(4*T,y(t==4*T),'bo');  // Respuesta t=4T
xgrid; xtitle('Sistema de primer orden - Respuesta a escalón', 't', 'y');

