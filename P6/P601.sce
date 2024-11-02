clear; clc; 
// P601.sce
s = syslin('c',%s,1); 

// DOMINIO DE LAPLACE

// Proceso de segundo orden sobreamortiguado
Kp = 5; Tp1 = 5; Tp2 = 2; 
Gp = Kp/((Tp1*s+1)*(Tp2*s+1)) 

// Válvula de primer orden
Kv = 0.5; Tv = 1; 
Gv = Kv/(Tv*s+1) 

// Medida ideal
Gm = 1; 

// Ganancia y periodo últimos suponiendo control P
Grl = Gp*Gv*Gm 
[Kcu,omegaui] = kpure(Grl)
omegau = abs(omegaui)
Pu = 2*%pi/omegau

// SINTONIZACIÓN

// Ziegler-Nichols
   Kc = 0.50*Kcu;                             P = Kc; I = 0;     D = 0;     // P
// Kc = 0.45*Kcu; Ti = 0.83*Pu;               P = Kc; I = Kc/Ti; D = 0;     // PI
// Kc = 0.60*Kcu; Ti = 0.50*Pu; Td = 0.13*Pu; P = Kc; I = Kc/Ti; D = Kc*Td; // PID

// Tyreus-Luyben
// Kc = 0.50*Kcu;                             P = Kc; I = 0;     D = 0;     // P
// Kc = 0.31*Kcu; Ti = 2.20*Pu;               P = Kc; I = Kc/Ti; D = 0;     // PI
// Kc = 0.45*Kcu; Ti = 2.20*Pu; Td = 0.16*Pu; P = Kc; I = Kc/Ti; D = Kc*Td; // PID

// Controlador
Gc = P + I/s + D*s  

// Servomecanismo
Gcl = Gc*Gv*Gp/(1+Gm*Gc*Gv*Gp) 
polos = roots(Gcl.den)
[omegancl,zcl] = damp(Gcl)

scf(1); clf(1); 
plzr(Gcl); // Gráfico de polos
sgrid(zcl,omegancl);
xtitle('','','');
a1 = gca; 
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
a1.data_bounds = [-2,-2;2,2];
a1.isoview = 'on';
a1.box = 'off';

// DOMINIO DEL TIEMPO

// Respuesta temporal a escalón
dt = 0.01; tfin = 100; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
e = 1 - y;
offset = e($)
[yp,indexp] = max(y)
tp = t(indexp)

scf(2); clf(2); 
plot(t,y,tp,yp,'ro'); 
xgrid; xlabel('t'); ylabel('y');

// DOMINIO DE LA FRECUENCIA

// Márgenes de ganancia y fase
Gol = Gc*Gv*Gp*Gm
scf(3); clf(3);
show_margins(Gol);
[MgdB,fcf] = g_margin(Gol)
Mg = 10^(MgdB/20)
[Mf,fcg] = p_margin(Gol)
tdmax = Mf/(fcg*360)
