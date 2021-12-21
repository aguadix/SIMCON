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

// Control P
 Kc = 0.50*Kcu; 
 P = Kc; I = 0; D = 0; 
 Grl = Gp*Gv*Gm 

// Control PI
// Kc = 0.45*Kcu; Ti = 0.83*Pu; 
// P = Kc; I = Kc/Ti; D = 0; 
// Grl = (1+1/(Ti*s))*Gp*Gv*Gm

// Control PID
// Kc = 0.60*Kcu; Ti = 0.50*Pu; Td = 0.13*Pu;
// P = Kc; I = Kc/Ti; D = Kc*Td; 
// Grl = (1+1/(Ti*s)+Td*s)*Gp*Gv*Gm

// Tyreus-Luyben

// Control P
// Kc = 0.50*Kcu; 
// P = Kc; I = 0; D = 0; 
// Grl = Gp*Gv*Gm 

// Control PI
// Kc = 0.31*Kcu; Ti = 2.20*Pu; 
// P = Kc; I = Kc/Ti; D = 0; 
// Grl = (1+1/(Ti*s))*Gp*Gv*Gm

// Control PID
// Kc = 0.45*Kcu; Ti = 2.20*Pu; Td = 0.16*Pu;
// P = Kc; I = Kc/Ti; D = Kc*Td; 
// Grl = (1+1/(Ti*s)+Td*s)*Gp*Gv*Gm

// Lugar de las raíces
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
a1.children.children(1).foreground = 2;
a1.children.children(2).foreground = 13;
a1.children.children(3).foreground = 5;
//a1.children.children(4).foreground = 7;
a1.children.children(1).thickness = 3;
a1.children.children(2).thickness = 3;
a1.children.children(3).thickness = 3;
//a1.children.children(4).thickness = 3;

// Controlador
Gc = P + I/s + D*s  

// Servomecanismo
Gcl = Gc*Gv*Gp/(1+Gm*Gc*Gv*Gp) 
polos = roots(Gcl.den)
plot(real(polos),imag(polos),'ko');
[omegancl,zcl] = damp(Gcl)
sgrid(zcl,omegancl);

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
xgrid; xtitle('Respuesta temporal a escalón', 't', 'y');

// DOMINIO DE LA FRECUENCIA

// Márgenes de ganancia y fase
Gol = Gc*Gv*Gp*Gm
scf(3); clf(3);
show_margins(Gol);
[MgdB,fcf] = g_margin(Gol)
Mg = 10^(MgdB/20)
[Mf,fcg] = p_margin(Gol)
tdmax = Mf/(fcg*360)

// Resonancia
fr = freson(Gcl)
[dBmax,phir] = dbphi(repfreq(Gcl,fr))
scf(4); clf(4); 
gainplot(Gcl)
plot(fr,dBmax,'ro')
