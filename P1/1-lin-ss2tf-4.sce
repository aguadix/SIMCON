// 1-lin-ss2tf-4.sce
// Obtención de la función de transferencia a partir de un modelo teórico
// RCMP en serie
clear; clc;

CA0 = 1; // mol/L
V1 = 10; // L
V2 = 10; // L
k = 0.1; // h-1

F = 1; // L/h

function dxdt = f(x)
    dxdt(1) = F*(CA0 - x(1))/V1 - k*x(1)
    dxdt(2) = F*(x(1) - x(2))/V2 - k*x(2)
endfunction

CA1eeguess = 1; CA2eeguess = 1; // mol/L
xeeguess = [CA1eeguess; CA2eeguess];
xee = fsolve(xeeguess, f);
CA1ee = xee(1)
CA2ee = xee(2)

function [y,dxdt] = SNL(x,u)
    F = u
    dxdt = f(x)
    y = x(2)
endfunction

u = F;
SL = lin(SNL,xee,u)
G = ss2tf(SL)
