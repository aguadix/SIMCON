// 1-lin-ss2tf-2.sce
// Obtención de la función de transferencia a partir de un modelo teórico
// Tanque encamisado
clear; clc;

F = 0.1; // m3/h
V = 1; // m3
U = 1E4; // J/(h*m2*ºC)
A = 10; // m2
TJ = 90; // ºC
RHO = 1000; // kg/m3
CP = 4180; // J/(kg*ºC)

T0 = 10; // ºC

function dxdt = f(x)
    dxdt = F*(T0 - x)/V + U*A*(TJ-x)/(V*RHO*CP)
endfunction

Teeguess = 10; // ºC
xeeguess = Teeguess;
xee = fsolve(xeeguess,f);
Tee = xee

function [y,dxdt] = SNL(x,u)
    T0 = u
    dxdt = f(x)
    y = x
endfunction

u = T0;
SL = lin(SNL,xee,u)
G = ss2tf(SL)