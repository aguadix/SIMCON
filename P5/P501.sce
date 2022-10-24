clear; clc; 
// P501.sce
s = syslin('c',%s,1);

// Proceso de primer orden
Kp = 2; Tp = 5; 
Gp = Kp/(Tp*s+1) 

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
xtitle('Lugar de las raíces','','');
a1 = gca(); 
a1.x_location = 'origin'; 
a1.y_location = 'origin'; 
db = 1; a1.data_bounds = [-db,-db;db,db];
a1.isoview = 'on';
a1.box = 'off';
a1.children.children(1).foreground = 2;
a1.children.children(1).thickness = 3;

// Controlador
Kc = 1; 
P = Kc; I = 0; D = 0; // P
Gc = P + I/s + D*s

// Servomecanismo
Gcl = Gc*Gv*Gp/(1+Gm*Gc*Gv*Gp)  // Servomecanismo
polos = roots(Gcl.den)
plot(real(polos),imag(polos),'ko');

// Respuesta temporal a escalón
dt = 0.01; tfin = 20; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
e = 1 - y;
offset = e($)

scf(2); clf(2); 
plot(t,y); 
xgrid; xtitle('Respuesta temporal a escalón', 't', 'y');
