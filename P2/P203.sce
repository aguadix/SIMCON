clear; clc;
// P203.sce
s = syslin('c',%s,1);

K = 3; T = 2; td = 5; n = 1; // Sistema de primer orden con tiempo muerto

function pade = pade(td,n) 
    for j=1:n 
        num(j) = ( factorial(2*n-j) * factorial(n) * (-td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
        den(j) = ( factorial(2*n-j) * factorial(n) * ( td*%s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
    end
    pade = (1+sum(num))/(1+sum(den))
endfunction 

G = K*pade(td,n)/(T*s+1)  // Función de transferencia

dt = 0.01; tfin = 20; t = 0:dt:tfin; // Tiempo 
u = 'step';  // Entrada
y = csim(u,t,G);  // Respuesta temporal

scf(1); clf(1); 
plot(t,y);  // Respuesta temporal
plot(td+T,y(t==td+T),'ro');  // Respuesta t=td+T
xgrid; xlabel('t'); ylabel('y');
