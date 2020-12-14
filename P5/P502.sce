clear; clc; s = %s;
// P502.sce

// Proceso de segundo orden sobreamortiguado
Kp = 1; Kd = 2; Tp1 = 5; Tp2 = 1; 
Gp = Kp/((Tp1*s+1)*(Tp2*s+1))
Gd = Kd/((Tp1*s+1)*(Tp2*s+1))

// Válvula ideal
Kv = 1; Gv = Kv

// Medida ideal
Gm = 1 

// Lugar de las raíces
Grl = syslin('c',Gv*Gp*Gm)
inicio = roots(Grl.den)
fin = roots(Grl.num)

Kcmax = 100;
scf(1); clf(1); 
evans(Grl,Kcmax); 
xtitle('Lugar de las raíces','','');
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
 
// Controlador
Kc = 0.5;
P = Kc; I = 0; D = 0; // P
Gc = P + I/s + D*s

// Regulador
Gcl = syslin('c', Gd/(1+Gm*Gc*Gv*Gp))
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
xgrid; xtitle('Respuesta temporal a escalón', 't', 'y');
