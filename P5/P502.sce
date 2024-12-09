clear; clc;
// P502.sce
s = syslin('c',%s,1);

// Proceso de segundo orden sobreamortiguado
Kp = 1; Kd = 2; Tp1 = 5; Tp2 = 1; 
Gp = Kp/((Tp1*s+1)*(Tp2*s+1))
Gd = Kd/((Tp1*s+1)*(Tp2*s+1))

// Válvula ideal
Kv = 1; Gv = Kv

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
db = 2; a1.data_bounds = [-db,-db;db,db];
a1.isoview = 'on';
a1.box = 'off';
a1.children.children(1).foreground = 13;
a1.children.children(2).foreground = 2;
a1.children.children(1).thickness = 3;
a1.children.children(2).thickness = 3;

// Ganancia para polos reales dobles
Kc2 = krac2(Grl)
Kc2t = 1/(Kv*Kp) * ((Tp1+Tp2)^2/(4*Tp1*Tp2)-1)
 
// Controlador
Kc = Kc2/2
// Kc = Kc2
// Kc = 1/(Kv*Kp) * ((Tp1+Tp2)^2/(Tp1*Tp2)-1)
P = Kc; I = 0; D = 0; // P
Gc = P + I/s + D*s

// Regulador
Gcl = Gd/(1+Gm*Gc*Gv*Gp)
polos = roots(Gcl.den)
plot(real(polos),imag(polos),'ko');
[omegancl,zcl] = damp(Gcl)
sgrid(zcl,omegancl);

// Respuesta temporal a escalón
dt = 0.01; tfin = 25; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
e = 0 - y;
offset = e($)

scf(2); clf(2); 
plot(t,y); 
xgrid; xlabel('t'); ylabel('y');
