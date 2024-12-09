clear; clc;
// P504.sce
s = syslin('c',%s,1);

// Proceso de segundo orden sobreamortiguado
Kp = 1; Tp1 = 5; Tp2 = 1; 
Gp = Kp/((Tp1*s+1)*(Tp2*s+1))

// Válvula de primer orden
Kv = 1; Tv = 0.5; Gv = Kv/(Tv*s+1) 

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
db = 4; a1.data_bounds = [-db,-db;db,db];
a1.isoview = 'on';
a1.box = 'off';
a1.children.children(1).foreground = 5;
a1.children.children(2).foreground = 13;
a1.children.children(3).foreground = 2;
a1.children.children(1).thickness = 3;
a1.children.children(2).thickness = 3;
a1.children.children(3).thickness = 3;

// Ganancia para polos reales dobles
Kc2 = krac2(Grl)
A = Tv*Tp1*Tp2;
B = Tv*Tp1+Tv*Tp2+Tp1*Tp2;
C = Tv+Tp1+Tp2;
D = (9*A*B*C - 2*B^3 + 2*sqrt(27*(A^2*B^2*C^2 - A^3*C^3) + B^6 - 9*A*B^4*C )) / (27*A^2)
Kc2t = 1/(Kv*Kp) * (D-1)

// Ganancia para polos imaginarios puros
[Kcu,omegaui] = kpure(Grl) 
Kcut = 1/(Kv*Kp) * ((1/Tv+1/Tp1+1/Tp2)*(Tv+Tp1+Tp2) - 1)
omegaut = sqrt((Tv+Tp1+Tp2)/(Tv*Tp1*Tp2))

// Controlador
Kc = Kc2/2  
// Kc = Kc2  
// Kc = (Kc2+Kcu)/2
// Kc = Kcu  
// Kc = 1.5*Kcu
P = Kc; I = 0; D = 0; // P
Gc = P + I/s + D*s

// Servomecanismo
Gcl = Gc*Gv*Gp/(1+Gm*Gc*Gv*Gp)
polos = roots(Gcl.den)
plot(real(polos),imag(polos),'ko');
[omegancl,zcl] = damp(Gcl)
sgrid(zcl,omegancl);

// Respuesta temporal a escalón
dt = 0.01; tfin = 25; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
e = 1 - y;
offset = e($)

scf(2); clf(2); 
plot(t,y); 
xgrid; xlabel('t'); ylabel('y');

// Márgenes de ganancia y fase
Gol = Gc*Gv*Gp*Gm
scf(3); clf(3);
show_margins(Gol);
[MgdB,fcf] = g_margin(Gol)
Mg = 10^(MgdB/20)
[Mf,fcg] = p_margin(Gol)
tdmax = Mf/(fcg*360)
