// 4-freq-n1td.sce
// Respuesta en frecuencia
// Sistema de primer orden con tiempo muerto
clear; clc; s = %s;

function pade = pade(td,n)
    for j=1:n 
        num(j) = ( factorial(2*n-j) * factorial(n) * (-td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
        den(j) = ( factorial(2*n-j) * factorial(n) * ( td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
    end
    pade = (1+sum(num))/(1+sum(den))
endfunction

K = 3; tau = 2; td = 1; n = 10;
G = syslin('c',K*pade(td,n)/(tau*s+1))

dt = 0.01; tfin = 12; t = 0:dt:tfin;
M = 1; f = 1; omega = 2*%pi*f; u = M*sin(omega*t);
y = csim(u,t,G);

scf(1); clf(1); 
plot(t,u,t,y); 
xgrid; xtitle('Sistema de primer orden con tiempo muerto', 't', 'u(azul), y(verde)');

fmin = 1E-3; fmax = 1E1;

scf(2); clf(2);
bode(G,fmin,fmax)
xtitle('Diagrama de Bode');

scf(3); clf(3);
nyquist(G,fmin,fmax,%f)
xtitle('Diagrama de Nyquist');