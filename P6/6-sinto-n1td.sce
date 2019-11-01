// 6-sinto-n1td.sce
// Sintonización para proceso de primer orden con tiempo muerto
clear; clc; s = %s;

function pade = pade(td,n)
    for j=1:n 
        num(j) = ( factorial(2*n-j) * factorial(n) * (-td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
        den(j) = ( factorial(2*n-j) * factorial(n) * ( td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
    end
    pade = (1+sum(num))/(1+sum(den))
endfunction

// Elementos del sistema
Kv = 1;  Gv = Kv; // Válcula ideal
Kp = 2 ; taup = 5 ; td = 1; n = 5;  Gp = Kp*pade(td,n)/(taup*s+1); // Proceso de primer orden con tiempo muerto
Gm = 1; // Medida ideal

// SINTONIZACIÓN

// Ziegler-Nichols
//Kc = taup/(Kp*td); P = Kc; I = 0; D = 0; // P
//Kc = 0.9*taup/(Kp*td); taui = 3.3*td; P = Kc; I = Kc/taui; D = 0; // PI
//Kc = 1.2*taup/(Kp*td); taui = 2*td; taud = 0.5*td; P = Kc; I = Kc/taui; D = Kc*taud; // PID

// Cohen-Coon
//Kc = taup/(Kp*td)*(1+td/(3*taup)); P = Kc; I = 0; D = 0; // P
Kc = taup/(Kp*td)*(0.9+td/(12*taup)); taui = td*(30+3*td/taup)/(9+20*td/taup); P = Kc; I = Kc/taui; D = 0; // PI
//Kc = taup/(Kp*td)*(1.33+td/(4*taup)); taui = td*(32+6*td/taup)/(13+8*td/taup); taud = 4*td/(11+2*td/taup); P = Kc; I = Kc/taui; D = Kc*taud; // PID

Gc = P + I/s + D*s
Gcl = syslin('c',Gc*Gv*Gp / (1+Gm*Gc*Gv*Gp)) // Servomecanismo
Gol = syslin('c',Gc*Gv*Gp*Gm)


// DOMINIO DEL TIEMPO

dt = 0.01; tfin = 25; t = 0:dt:tfin;
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
gainplot(Gcl);
plot(fr,dBmax,'ro');