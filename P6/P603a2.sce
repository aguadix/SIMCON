clear; clc;
// P603a2.sce
s = syslin('c',%s,1); 

// Proceso de segundo orden críticamente amortiguado
Kp = 1; Kd = 2; Tp = 10; 
Gp = Kp/(Tp*s+1)^2
Gd = Kd/(Tp*s+1)^2

// Válvula de primer orden
Kv = 1; Tv = 1; Gv = Kv/(Tv*s+1)

// Medida ideal
Gm = 1

// Controlador PI
Ti = 30;
Grl = (1+1/(Ti*s))*Gp*Gv*Gm;
Kcu = kpure(Grl)

// Respuesta temporal a escalón
dt = 0.01; tfin = 500; t = 0:dt:tfin;
u = 'step';

// Iterar Kc
Kcinterval = 10:0.5:Kcu;

for i = 1:length(Kcinterval)
    Kc = Kcinterval(i);
    P = Kc; I = Kc/Ti; D = 0;
    Gc = P + I/s + D*s;
    Gcl = Gd/(1+Gm*Gc*Gv*Gp); // Regulador
    y = csim(u,t,Gcl); // Respuesta temporal a escalón
    e = 0 - y; // Error
    ISE(i) = inttrap(t,e.^2); // Integral del cuadrado del error
end

[ISEmin,indexISEmin] = min(ISE)
Kcopt = Kcinterval(indexISEmin)

scf(1); clf(1);
plot(Kcinterval,ISE,'ro',Kcopt,ISEmin,'r.');
xgrid; xlabel('Kc'); ylabel('ISE');

// Controlador PI óptimo
Kc = Kcopt;
P = Kc; I = Kc/Ti; D = 0;
Gc = P + I/s + D*s
Gcl = Gd/(1+Gm*Gc*Gv*Gp)
y = csim(u,t,Gcl);

scf(2); clf(2);
plot(t,y);
xgrid; xlabel('t'); ylabel('y');
