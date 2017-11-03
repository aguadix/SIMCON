// 1-lin-ss2tf-6.sce
// Obtención de la función de transferencia a partir de un modelo teórico
// RCMP exotérmico encamisado
clear; clc;

CP = 0.8; // cal/(g*K)
RHO = 1000; // g/L
F = 20; // L/s
V = 1500; // L
UA = 10000; // cal/(K*s)
H = -80000; // cal/mol
T0 = 293; // K
CA0 = 2.5; // mol/L
k0 = 2.5E10; // 1/s
R = 1.987; // cal/(mol*K)
E = 21000; // cal/mol

TJ = 283; // K

function dxdt = f(x)
    k = k0*exp(-E/(R*x(2)))
    dxdt(1) = F*(CA0-x(1))/V - k*x(1)
    dxdt(2) = F *(T0 - x(2))/V + UA*(TJ-x(2))/(V*RHO*CP) + (-H)*k*x(1)/(RHO*CP)
endfunction

CAeeguess = 0; // mol/L
Teeguess = 500; // K
xeeguess = [CAeeguess; Teeguess];
xee = fsolve(xeeguess, f);
CAee = xee(1)
Tee = xee(2)

function [y,dxdt] = SNL(x,u)
    TJ = u
    dxdt = f(x)
    y = x(2)
endfunction

u = TJ;
SL = lin(SNL,xee,u)
G = ss2tf(SL)

