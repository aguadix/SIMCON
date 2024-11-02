clear; clc; 
// P202.sce
s = syslin('c',%s,1);

// Sistema de primer orden con tiempo muerto
function pade = pade(td,n) 
    for j=1:n 
        num(j) = ( factorial(2*n-j) * factorial(n) * (-td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
        den(j) = ( factorial(2*n-j) * factorial(n) * ( td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
    end
    pade = (1+sum(num))/(1+sum(den))
endfunction 

K = 3; T = 2; td = 5; n = 10; 
G = K*pade(td,n)/(T*s+1)

// Respuesta temporal
dt = 0.01; tfin = 20; t = 0:dt:tfin;
u = 'impuls';
// u = 'step';
y = csim(u,t,G);  

scf(1); clf(1); 
plot(t,y);
xgrid; xlabel('t'); ylabel('y');
