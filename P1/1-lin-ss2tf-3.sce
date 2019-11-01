// 1-lin-ss2tf-3.sce
// Obtención de la función de transferencia a partir de un modelo teórico
// RCMP isotermo
clear; clc;

F = 1; // L/h
V = 10; // L
k = 0.1; // h-1

CA0 = 1; // mol/L

function dxdt = f(x)
    dxdt = F*(CA0 - x)/V - k*x
endfunction

CAeeguess = 1; // mol/L
xeeguess = CAeeguess;
xee = fsolve(xeeguess,f);
CAee = xee

function [y,dxdt] = SNL(x,u)
    CA0 = u
    dxdt = f(x)
    y = x
endfunction

u = CA0;
SL = lin(SNL,xee,u)
G = ss2tf(SL)
