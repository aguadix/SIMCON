clear; clc;
// P503.sce
s = syslin('c',%s,1);

// Proceso de segundo orden con numerador dinámico
Kp = 4; 
Tpn = 1; 
// Tpn = 1/3; 
// Tpn = 1/10; 
Tp1 = 1/2; Tp2 = 1/4; 
Gp = Kp*(Tpn*s+1)/((Tp1*s+1)*(Tp2*s+1))

// Válvula ideal
Kv = 0.25; Gv = Kv

// Medida ideal
Gm = 1 

// Lugar de las raíces
Grl = Gv*Gp*Gm
inicio = roots(Grl.den)
fin = roots(Grl.num)

Kcmax = 100;
scf(1); clf(1); 
evans(Grl,Kcmax);
xtitle('','','');
a1 = gca(); 
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
db = 20; a1.data_bounds = [-db,-db;db,db];
a1.isoview = 'on';
a1.box = 'off';
a1.children.children(1).foreground = 13;
a1.children.children(2).foreground = 2;
a1.children.children(1).thickness = 3;
a1.children.children(2).thickness = 3;

// Ganancia para polos reales dobles
Kc2 = krac2(Grl)
Kc2at = 1/(Kv*Kp) * (2*Tp1*Tp2-Tpn*Tp1-Tpn*Tp2 - 2*sqrt(Tp1*Tp2*(Tp1*Tp2 + Tpn*(Tpn-Tp1-Tp2))))/Tpn^2
Kc2bt = 1/(Kv*Kp) * (2*Tp1*Tp2-Tpn*Tp1-Tpn*Tp2 + 2*sqrt(Tp1*Tp2*(Tp1*Tp2 + Tpn*(Tpn-Tp1-Tp2))))/Tpn^2

// Ganancia para zmin
Kczmin = 1/(Kv*Kp) * (Tp1+Tp2-2*Tpn)/Tpn

// Controlador
Kc = 1; 
// Kc = Kc2at/2  
// Kc = Kc2at
// Kc = 0.9*Kczmin
// Kc = Kczmin
// Kc = 1.1*Kczmin
// Kc = Kc2bt
// Kc = 2*Kc2bt
P = Kc; I = 0; D = 0; // P
Gc = P + I/s + D*s

// Servomecanismo
Gcl = Gc*Gv*Gp/(1+Gm*Gc*Gv*Gp)
polos = roots(Gcl.den)
plot(real(polos),imag(polos),'ko');
[omegancl,zcl] = damp(Gcl)
sgrid(zcl,omegancl);

// Respuesta temporal a escalón
dt = 0.01; tfin = 10; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
e = 1 - y;
offset = e($)

scf(2); clf(2); 
plot(t,y); 
xgrid; xlabel('t'); ylabel('y');
