// 1-lin-ss2tf-1.sce
// Obtención de la función de transferencia a partir de un modelo teórico
// Tanque de balance
clear; clc;

F1 = 1; // m3/h
A = 0.5; // m2
k = 15; // m^2.5/h

F2 = 5; // m3/h

function dxdt = f(x)
    dxdt = (F1 + F2 - k*sqrt(x))/A
endfunction

heeguess = 0; // m
xeeguess = heeguess;
xee = fsolve(xeeguess,f);
hee = xee

function [y,dxdt] = SNL(x,u)
    F2 = u
    dxdt = f(x)
    y = x
endfunction

u = F2;
SL = lin(SNL,xee,u)
G = ss2tf(SL)