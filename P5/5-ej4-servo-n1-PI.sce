// 5-ej6-servo-n1-PI.sce
clear; clc; s = %s;

// DOMINIO DE LAPLACE

// Elementos del sistema
Kc = 10; taui = 0.5; P = Kc; I = Kc/taui; D = 0; Gc = P + I/s + D*s // Control PI
Kv = 1; Gv = Kv; // Válvula ideal
Kp = 1 ; taup = 1 ; Gp = Kp/(taup*s+1); // Proceso de primer orden
Gm = 1; // Medida ideal

// Funciones de transferencia
Gcl = syslin('c',Gc*Gv*Gp / (1+Gm*Gc*Gv*Gp))  // Servomecanismo
Gol = syslin('c',Gc*Gv*Gp*Gm)
Grl = syslin('c',(1+1/(taui*s))*Gv*Gp*Gm)

// Lugar de las raíces
inicio = roots(denom(Grl))
fin = roots(numer(Grl))

Kc2 = krac2(Grl) // Kc para polos reales dobles
[Kcu,omegaui] = kpure(Grl) // Kc para polos imaginarios puros

Kcmax = 10;
scf(1); clf(1); 
evans(Grl,Kcmax); 
sgrid;

// Polos y ceros
polos = roots(denom(Gcl))
ceros = roots(numer(Gcl))
[omegan,zeta] = damp(Gcl)

scf(2); clf(2); 
plzr(Gcl); 
sgrid(zeta,omegan);


// DOMINIO DEL TIEMPO
dt = 0.01; tfin = 5; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
yee = y($)
offset = 1 - yee

scf(3); clf(3); 
plot(t,y); 
xgrid; xtitle('Servomecanismo', 't', 'y');
