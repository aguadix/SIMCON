// 3-step-n1td.sce
// Respuesta a escalón
// Sistema de primer orden con tiempo muerto
clear; clc; s = %s;

function pade = pade(td,n)
    for j=1:n 
        num(j) = ( factorial(2*n-j) * factorial(n) * (-td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
        den(j) = ( factorial(2*n-j) * factorial(n) * ( td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
    end
    pade = (1+sum(num))/(1+sum(den))
endfunction

K = 3; tau = 2; td = 10; n = 5;
G = syslin('c',K*pade(td,n)/(tau*s+1))

u = 'step';
dt = 0.01; tfin = td + 5*tau; t = 0:dt:tfin;
y = csim(u,t,G);

scf(1); clf(1); 
plot(t,y); 
xgrid; xtitle('Sistema de primer orden con tiempo muerto', 't', 'y');