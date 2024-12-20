clear; clc; 
// P105.sce

// (a) CÁLCULO DEL ESTADO ESTACIONARIO

// Sistema de ecuaciones algebraicas
function dxdt = f(x)
    // Variables
    CA = x(1)
    CB = x(2)
    // Balance de materia para A
    dCAdt = F*(CA0-CA)/V - k1*CA - k3*CA^2
    // Balance de materia para B
    dCBdt = - F*CB/V + k1*CA - k2*CB
    // Derivadas
    dxdt(1) = dCAdt
    dxdt(2) = dCBdt
endfunction

// Constantes
k1 = 1.0; // h-1
k2 = 1.5; // h-1
k3 = 0.2; // L/(mol*h)
V = 10; // L
F = 10; // L/h
CA0 = 10; // mol/L

// Solución supuesta
CAeeguess = 10; CBeeguess = 0; // mol/L
xeeguess = [CAeeguess;CBeeguess];

// Resolver
xee = fsolve(xeeguess,f);
CAee = xee(1)
CBee = xee(2)

// (b) LINEALIZACIÓN ALREDEDOR DEL ESTADO ESTACIONARIO

// Derivadas parciales exactas
a11 = -F/V - k1 - 2*k3*CAee
a12 = 0
a21 = k1 
a22 = -F/V - k2
b11 = (CA0-CAee)/V
b21 = -CBee/V

// Sistema no lineal
function dxdt = SNL(x)
    CA = x(1)  // Variable de estado
    CB = x(2)  // Variable de estado
    F  = x(3)  // Variable de entrada
    // Balance de materia para A
    dCAdt = F*(CA0-CA)/V - k1*CA - k3*CA^2
    // Balance de materia para B
    dCBdt = - F*CB/V + k1*CA - k2*CB
    // Derivadas
    dxdt(1) = dCAdt
    dxdt(2) = dCBdt
endfunction

// Matriz jacobiana
u = F;
J = numderivative(SNL,[xee;u])

// Sistema lineal
A = J(:,1:2)
B = J(:,3)
C = [0,1]
SL = syslin('c',A,B,C)

// (c) FUNCIÓN DE TRANSFERENCIA

s = syslin('c',%s,1);
G = (B(2,1)*s+A(2,1)*B(1,1)-A(1,1)*B(2,1))/(s^2-(A(1,1)+A(2,2))*s+A(1,1)*A(2,2)-A(1,2)*A(2,1))
G = ss2tf(SL) 



