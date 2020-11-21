clear; clc;
// P301.sce
s = %s;

// Sistema de primer orden
K = 3; T = 2; 
G = syslin('c',K/(T*s+1)) 

f = 0.080; // Frecuencia
ciclos = 10; tfin = ciclos/f; dt = tfin/200; t = 0:dt:tfin; // Tiempo
M = 1; omega = 2*%pi*f; u = M*sin(omega*t);  // Entrada
y = csim(u,t,G);  // Respuesta temporal
repf = repfreq(G,f) // Respuesta compleja
[dB,phi] = dbphi(repf) // Magnitud y fase

scf(1); clf(1); 
plot(t,u,t,y);
xgrid; xtitle('Sistema de primer orden - Respuesta temporal a frecuencia','t','u(azul), y(verde)');

fmin = 0.001; fmax = 10;

scf(2); clf(2);
bode(G,fmin,fmax);
xtitle('Sistema de primer orden - Diagrama de Bode');

scf(3); clf(3);
xtitle('Sistema de primer orden - Diagrama de Bode');
subplot(2,1,1); gainplot(G,fmin,fmax); plot(f,dB,'ro');
subplot(2,1,2); phaseplot(G,fmin,fmax); plot(f,phi,'ro')

scf(4); clf(4);
nyquist(G,fmin,fmax,%f)
plot(real(repf),imag(repf),'ro');
xtitle('Sistema de primer orden - Diagrama de Nyquist','','');
a4 = gca; 
a4.x_location = 'origin'; 
a4.y_location = 'origin'; 
a4.data_bounds = [-3,-3;3,3];
a4.isoview = 'on';
a4.box = 'off';
