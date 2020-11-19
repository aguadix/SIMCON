clear; clc;
// P301.sce
s = %s;

K = 3; T = 2;  // Sistema de primer orden
G = syslin('c',K/(T*s+1))  // Función de transferencia

dt = 0.01; tfin = 50; t = 0:dt:tfin;  // Tiempo
M = 1; f = 0.1; omega = 2*%pi*f; u = M*sin(omega*t);  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,u,t,y); 
xgrid; xtitle('Sistema de primer orden - Respuesta frecuencial', 't', 'u(azul), y(verde)');

repf = repfreq(G,f) // Respuesta en frecuencia   
[dB,phi] = dbphi(repf)

fmin = 1E-3; fmax = 1E1;

scf(2); clf(2);
bode(G,fmin,fmax);
xtitle('Sistema de primer orden - Diagrama de Bode');

scf(3); clf(3);
gainplot(G,fmin,fmax);
plot(f,dB,'ro');
xtitle('Sistema de primer orden - Diagrama de Bode / Magnitud');

scf(4); clf(4);
phaseplot(G,fmin,fmax);
plot(f,phi,'ro');
xtitle('Sistema de primer orden - Diagrama de Bode / Fase');

scf(5); clf(5);
nyquist(G,fmin,fmax,%f)
plot(real(repf),imag(repf),'ro');
xtitle('Sistema de primer orden - Diagrama de Nyquist','','');
a3 = gca; 
a3.x_location = 'origin'; 
a3.y_location = 'origin'; 
a3.data_bounds = [-4,-4;4,4];
a3.isoview = 'on';
a3.box = 'off';
