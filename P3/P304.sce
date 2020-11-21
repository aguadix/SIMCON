clear; clc;
// P304.sce
s = %s;

// Sistema de segundo orden críticamente amortiguado
K = 1; T = 2; 
G = syslin('c',K/(T*s+1)^2)  

fmin = 1E-3; fmax = 1E1; f = logspace(log10(fmin),log10(fmax),1E4); // Frecuencia  
repf = repfreq(G,f); // Respuesta compleja
[dB,phi] = dbphi(repf);  // Magnitud y fase

// Frecuencia de corte
phic = -90;
indexc = find(phi<phic,1);
fc = f(indexc)
fct = 1/(2*%pi*T)
repfc = repf(indexc)
dBc = dB(indexc)
phic = phi(indexc)

ciclos = 10; tfin = ciclos/fc; dt = tfin/200; t = 0:dt:tfin; // Tiempo
M = 1; omega = 2*%pi*fc; u = M*sin(omega*t);  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,u,t,y);
xgrid; xtitle('Sistema de segundo orden críticamente amortiguado - Respuesta temporal a frecuencia','t','u(azul), y(verde)');

scf(2); clf(2);
bode(G,fmin,fmax);
xtitle('Sistema de segundo orden críticamente amortiguado - Diagrama de Bode');

scf(3); clf(3);
xtitle('Sistema de segundo orden críticamente amortiguado - Diagrama de Bode');
subplot(2,1,1); gainplot(G,fmin,fmax); plot(fc,dBc,'ro');
subplot(2,1,2); phaseplot(G,fmin,fmax); plot(fc,phic,'ro')

scf(4); clf(4);
nyquist(G,fmin,fmax,%f)
plot(real(repfc),imag(repfc),'ro');
xtitle('Sistema de segundo orden críticamente amortiguado - Diagrama de Nyquist','','');
a4 = gca; 
a4.x_location = 'origin'; 
a4.y_location = 'origin'; 
a4.data_bounds = [-1,-1;1,1];
a4.isoview = 'on';
a4.box = 'off';
