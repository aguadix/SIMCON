clear; clc; 
// P101.sce

// (a) CÁLCULO DEL ESTADO ESTACIONARIO

// Sistema de ecuaciones algebraicas
function dxdt = f(x)
    // Variables
    h = x
    // Balance de materia
    dhdt = (F1 + F2 - k*sqrt(h))/At
    // Derivadas
    dxdt = dhdt
endfunction

// Constantes
At = 0.5; // m2
F1 = 1; // m3/h
F2 = 5; // m3/h
k = 15; // m^2.5/h

// Solución supuesta
heeguess = 0; // m
xeeguess = heeguess;

// Resolver
xee = fsolve(xeeguess,f);
hee = xee

// (b) LINEALIZACIÓN ALREDEDOR DEL ESTADO ESTACIONARIO

// Derivadas parciales exactas
A = -k/(2*At*sqrt(hee))
B = 1/At

// Sistema no lineal
function dxdt = SNL(x)
    h = x(1)   // Variable de estado
    F2 = x(2)  // Variable de entrada
    // Balance de materia
    dhdt = (F1 + F2 - k*sqrt(h))/At
    // Derivadas
    dxdt = dhdt
endfunction

// Matriz jacobiana
u = F2;
J = numderivative(SNL,[xee;u])

// Sistema lineal
A = J(1,1)
B = J(1,2)
C = 1
SL = syslin('c',A,B,C)

// (c) FUNCIÓN DE TRANSFERENCIA

s = syslin('c',%s,1);
G = B/(s-A)
G = ss2tf(SL)
