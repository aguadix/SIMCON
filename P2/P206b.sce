clear; clc;
// P206b.sce
s = syslin('c',%s,1);

// Sistema de segundo orden sobreamortiguado con numerador dinámico
// K = 1; Tn = 8; T1 = 4; T2 = 2; 
// G = K*(Tn*s+1)/((T1*s+1)*(T2*s+1)) 
// Sistema de segundo orden críticamente amortiguado con numerador dinámico
// K = 1; Tn = 8; T = 4; 
// G = K*(Tn*s+1)/(T*s+1)^2 
// Sistema de segundo orden subamortiguado con numerador dinámico
 K = 1; Tn = 0.5; T = 5; z = 0.25; 
 G = K*(Tn*s+1)/(T^2*s^2 + 2*z*T*s + 1) 
 
// Polos y ceros
polos = roots(G.den)
ceros = roots(G.num)
scf(1); clf(1); 
plzr(G);
xtitle('','','');
a1 = gca; 
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
a1.data_bounds = [-2,-2;2,2];
a1.isoview = 'on';
a1.box = 'off';

// Respuesta temporal
dt = 0.01; tfin = 120; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,G);  

scf(2); clf(2); 
plot(t,y);
xgrid; xlabel('t'); ylabel('y');
