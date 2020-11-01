clear; clc;
// P1-06.sce

// (a) CÁLCULO DEL ESTADO ESTACIONARIO

// Sistema de ecuaciones algebraicas
function dxdt = f(x)
    // Variables
    CA = x(1)
    T  = x(2)
    // Ecuación de Arrhenius
    k = k0*exp(-E/(R*T))
    // Balance de materia para A
    dCAdt = F*(CA0-CA)/V - k*CA
    // Balance de energía
    dTdt = F *(T0-T)/V + UA*(TJ-T)/(V*RHO*CP) - H*k*CA/(RHO*CP)
    // Derivadas
    dxdt(1) = dCAdt
    dxdt(2) = dTdt
endfunction

// Constantes
TJ = 283; // K
CP = 0.8; // cal/(g*K)
RHO = 1000; // g/L
F = 20; // L/s
V = 1500; // L
UA = 1E4; // cal/(K*s)
H = -8E4; // cal/mol
T0 = 293; // K
CA0 = 2.5; // mol/L
k0 = 2.5E10; // 1/s
R = 1.987; // cal/(mol*K)
E = 2.1E4; // cal/mol

// Solución supuesta
CAeeguess = 0; // mol/L
Teeguess = 500; // K
xeeguess = [CAeeguess;Teeguess];

// Resolver
xee = fsolve(xeeguess,f);
CAee = xee(1)
Tee = xee(2)

// (b) LINEALIZACIÓN EN TORNO AL ESTADO ESTACIONARIO

// Derivadas parciales exactas

kee = k0*exp(-E/(R*Tee))
 
a11 = -F/V - kee
a12 = -CAee*kee*E/(R*Tee^2)
a21 = -H*kee/(RHO*CP)
a22 = -F/V - UA/(V*RHO*CP) -H*CAee*kee*E/(RHO*CP*R*Tee^2) 
b11 = 0
b12 = UA/(V*RHO*CP)

// Sistema invariante en el tiempo
function dxdt = SNL(x)
    // Variables
    CA = x(1)
    T  = x(2)
    TJ = x(3)
    // Ecuación de Arrhenius
    k = k0*exp(-E/(R*T))
    // Balance de materia para A
    dCAdt = F*(CA0-CA)/V - k*CA
    // Balance de energía
    dTdt = F *(T0-T)/V + UA*(TJ-T)/(V*RHO*CP) - H*k*CA/(RHO*CP)
    // Derivadas
    dxdt(1) = dCAdt
    dxdt(2) = dTdt
endfunction

// Matriz jacobiana
J = numderivative(SNL,[xee;F])

// Sistema lineal
A = J(:,1:2)
B = J(:,3)
C = [0,1]
SL = syslin('c',A,B,C)
