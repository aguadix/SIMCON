clear; clc; 
// P306.sce
s = syslin('c',%s,1);

// Sistema de segundo orden sobreamortiguado con numerador dinámico
 K = 1; Tn = 8; T1 = 4; T2 = 2; 
 G = K*(Tn*s+1)/((T1*s+1)*(T2*s+1)) 
 f0t = sqrt((Tn-T1-T2)/(Tn*T1*T2))/(2*%pi)

// Sistema de segundo orden críticamente amortiguado con numerador dinámico
// K = 1; Tn = 8; T = 2; 
// G = K*(Tn*s+1)/(T*s+1)^2 
// f0t = sqrt((Tn-2*T)/(Tn*T^2))/(2*%pi)

// Sistema de segundo orden subamortiguado con numerador dinámico
// K = 1; Tn = 2; T = 2; z = 0.2; 
// G = K*(Tn*s+1)/(T^2*s^2 + 2*z*T*s + 1) 
// f0t = sqrt((Tn-2*z*T)/(Tn*T^2))/(2*%pi)

fmin = 1E-3; fmax = 1E1; f = logspace(log10(fmin),log10(fmax),1E4); // Frecuencia
repf = repfreq(G,f); // Respuesta compleja
[dB,phi] = dbphi(repf);  // Magnitud y fase

index0 = find(phi<0,1);
f0 = f(index0)
repf0 = repf(index0)
dB0 = dB(index0)
phi0 = phi(index0)

ciclos = 10; tfin = ciclos/f0; dt = tfin/200; t = 0:dt:tfin; // Tiempo
M = 1; omega = 2*%pi*f0; u = M*sin(omega*t);  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,u,t,y);
xgrid; xlabel('t'); legend('u','y',-2,%f);

scf(2); clf(2);
bode(G,fmin,fmax);

scf(3); clf(3);
subplot(2,1,1); gainplot(G,fmin,fmax); plot(f0,dB0,'ro');
subplot(2,1,2); phaseplot(G,fmin,fmax); plot(f0,phi0,'ro')

scf(4); clf(4);
nyquist(G,fmin,fmax,%f)
plot(real(repf0),imag(repf0),'ro');
xtitle('','','');
a4 = gca; 
a4.x_location = 'origin'; 
a4.y_location = 'origin'; 
a4.data_bounds = [-3,-3;3,3];
a4.isoview = 'on';
a4.box = 'off';
