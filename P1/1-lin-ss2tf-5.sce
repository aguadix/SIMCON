// 1-lin-ss2tf-5.sce
// Obtención de la función de transferencia a partir de un modelo teórico
// RCMP con reacciones múltiples
clear; clc;

CA0 = 10; // mol/L
V = 10; // L
k1 = 1; // h-1
k2 = 1.5; // h-1
k3 = 0.2; // L/(mol*h)

F = 10; // L/h

function dxdt = f(x)
    dxdt(1) = F*(CA0 - x(1))/V - k1*x(1) - k3*x(1)^2
    dxdt(2) = - F*x(2)/V + k1*x(1) - k2*x(2)
endfunction

CAeeguess = 10; CBeeguess = 0; // mol/L
xeeguess = [CAeeguess; CBeeguess];
xee = fsolve(xeeguess, f);
CAee = xee(1)
CBee = xee(2)

function [y,dxdt] = SNL(x,u)
    F = u
    dxdt = f(x)
    y = x(2)
endfunction

u = F;
SL = lin(SNL,xee,u)
G = ss2tf(SL)
