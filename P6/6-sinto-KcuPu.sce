// 6-sinto-KcuPu.sce
// Sintonización basada en la ganancia y periodo últimos
clear; clc; s = %s;

// Elementos del sistema
Kv = 0.2; tauv = 1; Gv = Kv/(tauv*s+1); // Válvula de primer orden
Kp = 5; taup1 = 2; taup2 = 3; Gp = Kp/((taup1*s+1)*(taup2*s+1)); // Proceso de segundo orden sobreamortiguado
Gm = 1; // Medida ideal


// SINTONIZACIÓN

// Ganancia y periodo últimos
Grl = syslin('c',Gv*Gp*Gm) // Suponiendo control P
[Kcu,omegaui] = kpure(Grl) // Kc para polos imaginarios puros
omegau = abs(omegaui)
Pu = 2*%pi/omegau

// Ziegler-Nichols
Kc = 0.50*Kcu; P = Kc; I = 0; D = 0; // P
//Kc = 0.45*Kcu; taui = 0.83*Pu; P = Kc; I = Kc/taui; D = 0;// PI
//Kc = 0.60*Kcu; taui = 0.50*Pu; taud = 0.13*Pu; P = Kc; I = Kc/taui; D = Kc*taud; // PID

// Tyreus-Luyben
//Kc = 0.50*Kcu; P = Kc; I = 0; D = 0; // P
//Kc = 0.31*Kcu; taui = 2.20*Pu; P = Kc; I = Kc/taui; D = 0; // PI
//Kc = 0.450*Kcu; taui = 2.20*Pu; taud = 0.16*Pu; P = Kc; I = Kc/taui; D = Kc*taud; // PID

Gc = P + I/s + D*s
Gcl = syslin('c',Gc*Gv*Gp / (1+Gm*Gc*Gv*Gp)) // Servomecanismo
Gol = syslin('c',Gc*Gv*Gp*Gm)


// DOMINIO DE LAPLACE

// Polos y ceros
polos = roots(denom(Gcl))
ceros = roots(numer(Gcl))
[omegan,zeta] = damp(Gcl)
scf(1); clf(1); 
plzr(Gcl); 
sgrid;


// DOMINIO DEL TIEMPO

dt = 0.01; tfin = 100; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);

scf(2); clf(2); 
plot(t,y);
xgrid; xtitle('Servomecanismo', 't', 'y');

yee = y($)
E = 1-y; offset = E($) // Error estacionario
SE = E.^2; plot(t,SE,'g');
ISE = inttrap(t,SE) // Integral del error al cuadrado

// Tiempo de alzada (100%)
index1 = find(y>yee,1)
tr = t(index1)
yr = y(index1)
plot(tr,yr,'ro');

// Tiempo de pico y sobrepaso
[ymax,index2] = max(y)
tp = t(index2)
OS = (ymax-yee)/yee
plot(tp,ymax,'ro');

// Tiempo de asentamiento (2%)
index3 = max(find(abs(y-yee) > 0.02*yee))
ts = t(index3)
ys = y(index3)
plot(ts,ys,'ro');


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
[dBmax,phir] = dbphi(repfreq(Gcl,fr))
scf(5); clf(5); 
gainplot(Gcl)
plot(fr,dBmax,'ro')
