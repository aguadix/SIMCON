clear; clc;
// P603b2.sce
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
    Kc = x(1); Ti = x(2);
    P = Kc; I = Kc/Ti; D = 0; // Controlador PI
    Gc = P + I/s + D*s;  
    Gcl = Gd/(1+Gm*Gc*Gv*Gp); // Regulador
    y = csim(u,t,Gcl); 
endfunction

// Integral del cuadrado del error
function ISE = fobj(x)
    y = f(x)
    e = 0 - y; // Error
    ISE = inttrap(t,e.^2);
endfunction

// Valores óptimos supuestos
Kcoptguess = 10; Tioptguess = 10;
scf(1); clf(1);
plot(Kcoptguess,Tioptguess,'go');
xlabel('Kc'); ylabel('Ti')
xoptguess = [Kcoptguess,Tioptguess];
yoptguess = f(xoptguess);
scf(2); clf(2);
xgrid; xlabel('t'); ylabel('y');
plot(t,yoptguess,'g-');
ISEguess = fobj(xoptguess)

// Región estable
Tiinterval = [1:1:50];
for i = 1:length(Tiinterval)
    Ti = Tiinterval(i); 
    Grl = (1+1/(Ti*s))*Gp*Gv*Gm;
    Kcu(i) = kpure(Grl);
end
scf(1);
plot(Kcu,Tiinterval,'r-');

// Determinar Kc y Ti para minimizar ISE

function stop = outfun(x,optimValues,state)
    scf(1); xnumb(x(1),x(2),optimValues.iteration);
    stop = %F;
endfunction

options = optimset ('Display','iter','OutputFcn',outfun,'MaxIter',100);

[xopt,ISEmin,exitflag,output] = fminsearch(fobj,xoptguess,options)

// Valores óptimos calculados
Kcopt = xopt(1), Tiopt = xopt(2)
scf(1); plot(Kcopt,Tiopt,'bo');
yopt = f(xopt);
scf(2); plot(t,yopt);
legend('guess','optimal'); 
