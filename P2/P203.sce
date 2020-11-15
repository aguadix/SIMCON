clear; clc;
// P203.sce
s = %s;

K = 3; T = 2; td = 5; n = 1; // Sistema de primer orden con tiempo muerto
exec pade.sci;  // Aproximación de Padé
G = syslin('c',K*pade(td,n)/(T*s+1))  // Función de transferencia

dt = 0.01; tfin = 20; t = 0:dt:tfin; // Tiempo 
u = 'step';  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,y,'b-');  // Respuesta temporal
plot(td+T,y(t==td+T),'bo');  // Respuesta t=td+T
xgrid; xtitle('Sistema de primer orden con tiempo muerto - Respuesta a escalón', 't', 'y');
