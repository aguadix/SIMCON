// 5-ej3-servo-n2num-P.sce
clear; clc; s = %s;

// DOMINIO DE LAPLACE

// Elementos del sistema
Kc = 0.25; P = Kc; I = 0; D = 0; Gc = P + I/s + D*s // Control P
Kv = 0.25; Gv = Kv; // Válvula ideal
Kp = 4; taupn = -1; taup1 = 1; taup2 = 5; Gp = Kp*(taupn*s+1) / ((taup1*s+1)*(taup2*s+1)); // Proceso de segundo orden con numerador dinámico
Gm = 1; // Medida ideal

// Funciones de transferencia
Gcl = syslin('c',Gc*Gv*Gp / (1+Gm*Gc*Gv*Gp))  // Servomecanismo
Gol = syslin('c',Gc*Gv*Gp*Gm)
Grl = syslin('c',Gv*Gp*Gm)


// Lugar de las raíces
inicio = roots(denom(Grl))
fin = roots(numer(Grl))

Kc2 = krac2(Grl) // Kc para polos reales dobles
[Kcu,omegaui] = kpure(Grl) // Kc para polos imaginarios puros

Kcmax = 40;
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
dt = 0.01; tfin = 30; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
yee = y($)
offset = 1 - yee

scf(3); clf(3); 
plot(t,y); 
xgrid; xtitle('Servomecanismo', 't', 'y');


// DOMINIO DE LA FRECUENCIA

// Márgenes de ganancia y fase
[MgdB,fcf] = g_margin(Gol)
Mg = 10^(MgdB/20)

[Mf,fcg] = p_margin(Gol)
tdmax = Mf/(fcg*360)

scf(4); clf(4); 
show_margins(Gol);

// Resonancia
fr = freson(Gcl)
//[dBmax,phir] = dbphi(repfreq(Gcl,fr))

scf(5); clf(5); 
gainplot(Gcl)
//plot(fr,dBmax,'ro')
