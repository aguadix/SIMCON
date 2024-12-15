clear; clc;
// P603a1.sce
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
Kc = 15; // Tantear Kc < Kcu para ISEmin
P = Kc; I = Kc/Ti; D = 0;
Gc = P + I/s + D*s

// Regulador
Gcl = Gd/(1+Gm*Gc*Gv*Gp)
    
// Respuesta temporal a escalón
dt = 0.01; tfin = 500; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);

scf(1); clf(1);
plot(t,y);
xgrid; xlabel('t'); ylabel('y');

// Error
e = 0 - y;

// Integral del cuadrado del error
ISE = inttrap(t,e.^2)

scf(2);
plot(Kc,ISE,'ro');
xgrid; xlabel('Kc'); ylabel('ISE');
