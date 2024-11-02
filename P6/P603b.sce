clear; clc; 
// P603.sci
s = syslin('c',%s,1); 

// Proceso de segundo orden críticamente amortiguado (variable manipulada)
Kp = 1, Tp = 10; Gp = Kp/(Tp*s+1)^2

// Proceso de segundo orden críticamente amortiguado (perturbación)
Kd = 2; Gd = Kd/(Tp*s+1)^2

// Válvula de primer orden
Kv = 1; Tv = 1; Gv = Kv/(Tv*s+1)

// Medida ideal
Gm = 1

// Optimizar Kc y Ti para minimizar ISE
Kcinterval = 10:1:20;
Tiinterval = 25:1:35;

for i = 1:length(Kcinterval)
  for j = 1:length(Tiinterval)
    Kc = Kcinterval(i);
    Ti = Tiinterval(j); 
    P = Kc; I = Kc/Ti; D = 0;// Controlador PI
    Gc = P + I/s + D*s;
    Gcl = Gd/(1+Gm*Gc*Gv*Gp); // Regulador
    dt = 0.01; tfin = 500; t = 0:dt:tfin;
    u = 'step';
    y = csim(u,t,Gcl); // Respuesta temporal a escalón
    e = 0 - y;// Error
    ISE(i,j) = inttrap(t,e.^2); // Integral del cuadrado del error
    [Kc,Ti,ISE(i,j)]
  end
end

[ISEmin,indexISEmin] = min(ISE)
Kcopt = Kcinterval(indexISEmin(1))
Tiopt = Tiinterval(indexISEmin(2))

// Controlador PI óptimo
Kc = Kcopt; Ti = Tiopt;
P = Kc; I = Kc/Ti; D = 0;
Gc = P + I/s + D*s
Gcl = Gd/(1+Gm*Gc*Gv*Gp)
y = csim(u,t,Gcl);

scf(1); clf(1);
plot(t,y);
xgrid; xlabel('t'); ylabel('y');
