clear; clc; 
// P602.sce
s = syslin('c',%s,1); 

// DOMINIO DE LAPLACE

// Proceso de primer orden con tiempo muerto
Kp = 2 ; Tp = 5 ; td = 1; n = 5;  
exec D:\SIMCON\pade.sci;
Gp = Kp*pade(td,n)/(Tp*s+1) 

// Válvula ideal
Kv = 1;  
Gv = Kv 

// Medida ideal
Gm = 1; 

// SINTONIZACIÓN

// Ziegler-Nichols

// Control P
 Kc = Tp/(Kp*td); 
 P = Kc; I = 0; D = 0;

// Control PI
// Kc = 0.9*Tp/(Kp*td); Ti = 3.3*td; 
// P = Kc; I = Kc/Ti; D = 0;

// Control PID
// Kc = 1.2*Tp/(Kp*td); Ti = 2*td; Td = 0.5*td;
// P = Kc; I = Kc/Ti; D = Kc*Td;

// Cohen-Coon

// Control P
// Kc = Tp/(Kp*td)*(1+td/(3*Tp)); 
// P = Kc; I = 0; D = 0;

// Control PI
// Kc = Tp/(Kp*td)*(0.9+td/(12*Tp)); Ti = td*(30+3*td/Tp)/(9+20*td/Tp); 
// P = Kc; I = Kc/Ti; D = 0;

// Control PID
// Kc = Tp/(Kp*td)*(1.33+td/(4*Tp)); Ti = td*(32+6*td/Tp)/(13+8*td/Tp); Td = 4*td/(11+2*td/Tp); 
// P = Kc; I = Kc/Ti; D = Kc*Td;

// Controlador
Gc = P + I/s + D*s

// Servomecanismo
Gcl = Gc*Gv*Gp/(1+Gm*Gc*Gv*Gp)

// DOMINIO DEL TIEMPO

// Respuesta temporal a escalón
dt = 0.01; tfin = 25; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);
e = 1 - y;
offset = e($)
[yp,indexp] = max(y)
tp = t(indexp)

scf(1); clf(1); 
plot(t,y,tp,yp,'ro'); 
xgrid; xtitle('Respuesta temporal a escalón', 't', 'y');

// DOMINIO DE LA FRECUENCIA

// Márgenes de ganancia y fase
Gol = Gc*Gv*Gp*Gm
scf(2); clf(2);
show_margins(Gol);
[MgdB,fcf] = g_margin(Gol)
Mg = 10^(MgdB/20)
[Mf,fcg] = p_margin(Gol)
tdmax = Mf/(fcg*360)  
