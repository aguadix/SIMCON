clear; clc;
// P201b.sce
s = syslin('c',%s,1);

// Sistema de primer orden
K = 1; T = 1;  
G = K/(T*s+1)

// Polos y ceros
polos = roots(G.den)
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
dt = 0.01; tfin = 10; t = 0:dt:tfin;
u = 'step';  //
y = csim(u,t,G);  

scf(2); clf(2); 
plot(t,y);
for n = 1:4
  plot(n*T,y(t==n*T),'ro');
end
xgrid; xlabel('t'); ylabel('y');
