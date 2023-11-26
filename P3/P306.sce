clear; clc; 
// P306.sce
s = syslin('c',%s,1);

// Sistema de segundo orden sobreamortiguado con numerado
K = 1; T1 = 4; T2 = 1; Tn = 8; 
G = K*(Tn*s+1)/((T1*s+1)*(T2*s+1)) 

fmin = 1E-3; fmax = 1E1; f = logspace(log10(fmin),log10(fmax),1E4); // Frecuencia
repf = repfreq(G,f); // Respuesta compleja
[dB,phi] = dbphi(repf);  // Magnitud y fase

// Frecuencia objetivo
phiobj = 0;
indexobj = find(phi<phiobj,1);
fobj = f(indexobj)
repfobj = repf(indexobj)
dBobj = dB(indexobj)
phiobj =phi(indexobj)

ciclos = 10; tfin = ciclos/fobj; dt = tfin/200; t = 0:dt:tfin; // Tiempo
M = 1; omega = 2*%pi*fobj; u = M*sin(omega*t);  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,u,t,y);
xgrid; xlabel('t'); legend('u','y',-2,%f);

scf(2); clf(2);
bode(G,fmin,fmax);

scf(3); clf(3);
subplot(2,1,1); gainplot(G,fmin,fmax); plot(fobj,dBobj,'ro');
subplot(2,1,2); phaseplot(G,fmin,fmax); plot(fobj,phiobj,'ro')

scf(4); clf(4);
nyquist(G,fmin,fmax,%f)
plot(real(repfobj),imag(repfobj),'ro');
xtitle('Sistema de segundo orden sobreamortiguado con numerador dinámico - Diagrama de Nyquist','','');
a4 = gca; 
a4.x_location = 'origin'; 
a4.y_location = 'origin'; 
a4.data_bounds = [-2,-2;2,2];
a4.isoview = 'on';
a4.box = 'off';
