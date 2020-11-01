clear; clc;
// P102.sce

// (a) CÁLCULO DEL ESTADO ESTACIONARIO

// Sistema de ecuaciones algebraicas
function dxdt = f(x)
    // Variables
    T = x(1)
    // Balance de energía
    dTdt = F*(T0-T)/V + UA*(TJ-T)/(V*RHO*CP)
    // Derivadas
    dxdt(1) = dTdt
endfunction

// Constantes
V = 1; // m3
F = 0.1; // m3/h
T0 = 10; // ºC
TJ = 90; // ºC
UA = 1E5; // J/(h*ºC)
RHO = 1000; // kg/m3
CP = 4180; // J/(kg*ºC)

// Solución supuesta
Teeguess = 10; // ºC
xeeguess = Teeguess;

// Resolver
xee = fsolve(xeeguess,f);
Tee = xee

// (b) LINEALIZACIÓN ALREDEDOR DEL ESTADO ESTACIONARIO

// Derivadas parciales exactas
A = -F/V - UA/(V*RHO*CP)
B = F/V

// Sistema invariante en el tiempo
function dxdt = SNL(x)
    // Variables
    T = x(1)
    T0 = x(2)
    // Balance de energía
    dTdt = F*(T0-T)/V + UA*(TJ-T)/(V*RHO*CP)
    // Derivadas
    dxdt(1) = dTdt
endfunction

// Matriz jacobiana
u = T0;
J = numderivative(SNL,[xee;T0])

// Sistema lineal
A = J(1,1)
B = J(1,2)
C = 1
SL = syslin('c',A,B,C)
