// 5-ej2-reg-n2sob-P.sce
clear; clc; s = %s;

// DOMINIO DE LAPLACE

// Elementos del sistema
Kc = 0.8; P = Kc; I = 0; D = 0; Gc = P + I/s + D*s // Control P
Kv = 1; Gv = Kv; // Válvula ideal
Kp = 1; taup1 = 1; taup2 = 5; Gp = Kp/((taup1*s+1)*(taup2*s+1)); // Proceso de segundo orden sobreamortiguado(entrada manipulada)
Kd = 2; Gd = Kd/((taup1*s+1)*(taup2*s+1)); // Proceso de segundo orden sobreamortiguado (entrada perturbación)
Gm = 1; // Medida ideal

// Funciones de transferencia
Gcl = syslin('c', Gd/(1+Gm*Gc*Gv*Gp)) // Regulador
Gol = syslin('c',Gc*Gv*Gp*Gm)
Grl = syslin('c',Gv*Gp*Gm)

// Lugar de las raíces
inicio = roots(denom(Grl))
fin = roots(numer(Grl))

Kc2 = krac2(Grl) // Kc para polos reales dobles
[Kcu,omegaui] = kpure(Grl) // Kc para polos imaginarios puros

Kcmax = 12;
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
dt = 0.01; tfin = 20; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
yee = y($)
offset = 0 - yee

scf(3); clf(3); 
plot(t,y); 
xgrid; xtitle('Regulador', 't', 'y');
