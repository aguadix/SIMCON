clear; clc;
// P104.sce

// (a) CÁLCULO DEL ESTADO ESTACIONARIO

// Sistema de ecuaciones algebraicas
function dxdt = f(x)
    // Variables
    CA1 = x(1)
    CA2 = x(2)
    // Balance de materia en el reactor 1
    dCA1dt = F*(CA0-CA1)/V1 - k*CA1
    // Balance de materia en el reactor 2
    dCA2dt = F*(CA1-CA2)/V2 - k*CA2
    // Derivadas
    dxdt(1) = dCA1dt
    dxdt(2) = dCA2dt
endfunction

// Constantes
k = 0.1; // h-1
V1 = 10; // L
V2 = 10; // L
F = 1; // L/h
CA0 = 1; // mol/L

// Solución supuesta
CA1eeguess = 1; CA2eeguess = 1; // mol/L
xeeguess = [CA1eeguess; CA2eeguess];

// Resolver
xee = fsolve(xeeguess, f);
CA1ee = xee(1)
CA2ee = xee(2)

// (b) LINEALIZACIÓN ALREDEDOR DEL ESTADO ESTACIONARIO

// Derivadas parciales exactas
a11 = -F/V1 - k
a12 = 0
a21 = F/V2 
a22 = -F/V2 - k
b11 = (CA0-CA1ee)/V1
b21 = (CA1ee-CA2ee)/V2

// Sistema no lineal
function dxdt = SNL(x)
    CA1 = x(1)  // Variable de estado
    CA2 = x(2)  // Variable de estado
    F   = x(3)  // Variable de entrada
    // Balance de materia en el reactor 1
    dCA1dt = F*(CA0-CA1)/V1 - k*CA1
    // Balance de materia en el reactor 2
    dCA2dt = F*(CA1-CA2)/V2 - k*CA2
    // Derivadas
    dxdt(1) = dCA1dt
    dxdt(2) = dCA2dt
endfunction

// Matriz jacobiana
u = F;
J = numderivative(SNL,[xee;u])

// Sistema lineal
A = J(:,1:2)
B = J(:,3)
C = [0,1]
SL = syslin('c',A,B,C)
