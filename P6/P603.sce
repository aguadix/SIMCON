clear; clc; s = %s;
// P603.sci 

// Proceso de segundo orden críticamente amortiguado (variable manipulada)
Kp = 1, Tp = 10; Gp = Kp/(Tp*s+1)^2

// Proceso de segundo orden críticamente amortiguado (perturbación)
Kd = 2; Gd = Kd/(Tp*s+1)^2

// Válvula de primer orden
Kv = 1; Tv = 1; Gv = Kv/(Tv*s+1)

// Medida ideal
Gm = 1

dt = 0.01; tfin = 500; t = 0:dt:tfin;
u = 'step';

function y = f(x)
    // Controlador PI
    Kc = x(1);
    Ti = x(2);
    P = Kc; I = Kc/Ti; D = 0;
    Gc = P + I/s + D*s;
    // Regulador
    Gcl = syslin('c',Gd/(1+Gm*Gc*Gv*Gp));
    // Respuesta temporal a escalón
    y = csim(u,t,Gcl);
endfunction

function ISE = fobj(x)
    // Respuesta temporal a escalón
    y = f(x)
    // Error
    e = 0 - y;
    // Integral del cuadrado del error
    ISE = inttrap(t,e.^2);
endfunction

// Valores óptimos supuestos
Kcoptguess = 10;
Tioptguess = 10;
scf(1); clf(1);
plot(Kcoptguess,Tioptguess,'go');
xtitle('Optimización con el algoritmo Nelder-Mead','Kc','Ti');
xoptguess = [Kcoptguess,Tioptguess];
yoptguess = f(xoptguess);
scf(2); clf(2);
xgrid; xtitle('Respuesta temporal a escalón','t','y');
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

// Minimizar ISE con el algoritmo Nelder-Mead

function stop = outfun(x,optimValues,state)
    scf(1); xnumb(x(1),x(2),optimValues.iteration);
    stop = %F;
endfunction

options = optimset ('Display','iter','OutputFcn',outfun,'MaxIter',100);

[xopt,ISEmin,exitflag,output] = fminsearch(fobj,xoptguess,options)

// Valores óptimos calculados
Kcopt = xopt(1)
Tiopt = xopt(2)
scf(1); plot(Kcopt,Tiopt,'bo');
yopt = f(xopt);
scf(2); plot(t,yopt,'b-');