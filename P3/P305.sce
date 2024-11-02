clear; clc; 
// P305.sce
s = syslin('c',%s,1);

// Sistema de segundo orden subamortiguado
K = 1; T = 2; z = 0.4; 
G = K/(T^2*s^2+2*z*T*s+1) 

fmin = 1E-3; fmax = 1E1; f = logspace(log10(fmin),log10(fmax),1E4); // Frecuencia
repf = repfreq(G,f); // Respuesta compleja
[dB,phi] = dbphi(repf);  // Magnitud y fase

// Frecuencia de resonancia
[dBr,indexr] = max(dB)
fr = f(indexr)
fr = freson(G)
frt = sqrt(1-2*z^2)/(2*%pi*T)
repfr = repf(indexr)
phir = phi(indexr)

ciclos = 10; tfin = ciclos/fr; dt = tfin/200; t = 0:dt:tfin; // Tiempo
M = 1; omega = 2*%pi*fr; u = M*sin(omega*t);  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,u,t,y);
xgrid; xlabel('t'); legend('u','y',-2,%f);

scf(2); clf(2);
bode(G,fmin,fmax);

scf(3); clf(3);
subplot(2,1,1); gainplot(G,fmin,fmax); plot(fr,dBr,'ro');
subplot(2,1,2); phaseplot(G,fmin,fmax); plot(fr,phir,'ro')

scf(4); clf(4);
nyquist(G,fmin,fmax,%f)
plot(real(repfr),imag(repfr),'ro');
xtitle('','','');
a4 = gca; 
a4.x_location = 'origin'; 
a4.y_location = 'origin'; 
a4.data_bounds = [-1.5,-1.5;1.5,1.5];
a4.isoview = 'on';
a4.box = 'off';
