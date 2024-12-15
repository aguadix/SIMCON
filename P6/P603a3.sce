clear; clc;
// P603a3.sce
s = syslin('c',%s,1); 

// Proceso de segundo orden críticamente amortiguado
Kp = 1; Kd = 2; Tp = 10; 
Gp = Kp/(Tp*s+1)^2
Gd = Kd/(Tp*s+1)^2

// Válvula de primer orden
Kv = 1; Tv = 1; Gv = Kv/(Tv*s+1)

// Medida ideal
Gm = 1

// Respuesta temporal a escalón
dt = 0.01; tfin = 500; t = 0:dt:tfin;
u = 'step';

function y = f(x)
    Kc = x; Ti = 30;
    P = Kc; I = Kc/Ti; D = 0; // Controlador PI
    Gc = P + I/s + D*s;
    Gcl = Gd/(1+Gm*Gc*Gv*Gp); // Regulador
    y = csim(u,t,Gcl); 
endfunction

// Integral del cuadrado del error
function ISE = fobj(x)
    y = f(x);
    e = 0 - y; // Error
    ISE = inttrap(t,e.^2); 
endfunction

// Valores óptimos supuestos
Kcoptguess = 10;
xoptguess = Kcoptguess;
yoptguess = f(xoptguess);
ISEguess = fobj(xoptguess)

scf(1); clf(1);
plot(t,yoptguess,'g-');
xgrid; xlabel('t'); ylabel('y');

// Determinar Kc para minimizar ISE
options = optimset ('Display','iter');
[xopt,fobjmin,exitflag,output] = fminsearch(fobj,xoptguess,options)

// Valores óptimos calculados
Kcopt = xopt
ISEmin = fobjmin

yopt = f(xopt);
plot(t,yopt);
legend('guess','optimal'); 
