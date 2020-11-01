clear; clc;
// P103.sce

// (a) CÁLCULO DEL ESTADO ESTACIONARIO

// Sistema de ecuaciones algebraicas
function dxdt = f(x)
    // Variables
    CA = x(1)
    // Balance de materia
    dCAdt = F*(CA0-CA)/V - k*CA
    // Derivadas
    dxdt(1) = dCAdt
endfunction

// Constantes
k = 0.1; // h-1
V = 10; // L
F = 1; // L/h
CA0 = 1; // mol/L

// Solución supuesta
CAeeguess = 1; // mol/L
xeeguess = CAeeguess;

// Resolver
xee = fsolve(xeeguess,f);
CAee = xee

// (b) LINEALIZACIÓN ALREDEDOR DEL ESTADO ESTACIONARIO

// Derivadas parciales exactas
A = -F/V - k
B = F/V

// Sistema invariante en el tiempo
function dxdt = SNL(x)
    // Variables
    CA = x(1)
    CA0 = x(2)
    // Balance de materia
    dCAdt = F*(CA0-CA)/V - k*CA
    // Derivadas
    dxdt(1) = dCAdt
endfunction

// Matriz jacobiana
u = CA0;
J = numderivative(SNL,[xee;u])

// Sistema lineal
A = J(1,1)
B = J(1,2)
C = 1
SL = syslin('c',A,B,C)
