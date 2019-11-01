// 5-ej5-servo-n2sub-PI.sce
clear; clc; s = %s;

// DOMINIO DE LAPLACE

// Elementos del sistema
Kc = 5; taui = 0.2; P = Kc; I = Kc/taui; D = 0; Gc = P + I/s + D*s // Control PI
Kv = 0.05; Gv = Kv; // Válvula ideal
Kp = 0.1; taup = 0.5; zetap = 0.7; Gp = Kp/(taup^2*s^2+2*taup*zetap*s+1); // Proceso de segundo orden subamortiguado
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

Kcmax = 500;
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
dt = 0.01; tfin = 16; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
yee = y($)
offset = 1 - yee

scf(3); clf(3); 
plot(t,y); 
xgrid; xtitle('Servomecanismo', 't', 'y');
