clear; clc;
// P303.sce
s = %s;

// Sistema de segundo orden sobreamortiguado
K = 2; T1 = 5; T2 = 2; 
G = syslin('c',K/((T1*s+1)*(T2*s+1)))  

f = 0.051; // Frecuencia
ciclos = 10; tfin = ciclos/f; dt = tfin/200; t = 0:dt:tfin; // Tiempo
M = 1; omega = 2*%pi*f; u = M*sin(omega*t);  // Entrada
y = csim(u,t,G);  // Respuesta temporal
repf = repfreq(G,f) // Respuesta compleja
[dB,phi] = dbphi(repf) // Magnitud y fase

scf(1); clf(1); 
plot(t,u,t,y);
xgrid; xtitle('Sistema de segundo orden sobreamortiguado - Respuesta temporal a frecuencia','t','u(azul), y(verde)');

fmin = 0.001; fmax = 10;

scf(2); clf(2);
bode(G,fmin,fmax);
xtitle('Sistema de segundo orden sobreamortiguado - Diagrama de Bode');

scf(3); clf(3);
xtitle('Sistema de segundo orden sobreamortiguado - Diagrama de Bode');
subplot(2,1,1); gainplot(G,fmin,fmax); plot(f,dB,'ro');
subplot(2,1,2); phaseplot(G,fmin,fmax); plot(f,phi,'ro')

scf(4); clf(4);
nyquist(G,fmin,fmax,%f)
plot(real(repf),imag(repf),'ro');
xtitle('Sistema de segundo orden sobreamortiguado - Diagrama de Nyquist','','');
a4 = gca; 
a4.x_location = 'origin'; 
a4.y_location = 'origin'; 
a4.data_bounds = [-3,-3;3,3];
a4.isoview = 'on';
a4.box = 'off';
