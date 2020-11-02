clear; clc;
// P106.sce

// (a) CÁLCULO DEL ESTADO ESTACIONARIO

// Sistema de ecuaciones algebraicas
function dxdt = f(x)
    // Variables
    CA = x(1)
    T  = x(2)
    // Ecuación de Arrhenius
    k = k0*exp(-E/(R*T))
    // Balance de materia para A
    dCAdt = F*(CA0-CA)/V - k0*exp(-E/(R*T))*CA
    // Balance de energía
    dTdt = F *(T0-T)/V + UA*(TJ-T)/(V*RHO*CP) - H*k0*exp(-E/(R*T))*CA/(RHO*CP)
    // Derivadas
    dxdt(1) = dCAdt
    dxdt(2) = dTdt
endfunction

// Constantes
k0 = 2.5E10; // 1/s
E = 2.1E4; // cal/mol
H = -8E4; // cal/mol
R = 1.987; // cal/(mol*K)
CP = 1; // cal/(g*K)
RHO = 1000; // g/L
V = 1500; // L
F = 20; // L/s
T0 = 293; // K
CA0 = 2.5; // mol/L
TJ = 283; // K
UA = 1E4; // cal/(K*s)

// Solución supuesta
CAeeguess = 0; // mol/L
Teeguess = 500; // K
xeeguess = [CAeeguess;Teeguess];

// Resolver
xee = fsolve(xeeguess,f);
CAee = xee(1)
Tee = xee(2)

// (b) LINEALIZACIÓN ALREDEDOR DEL ESTADO ESTACIONARIO

// Derivadas parciales exactas
a11 = -F/V - k0*exp(-E/(R*Tee))
a12 = -k0*CAee*exp(-E/(R*Tee))*E/(R*Tee^2)
a21 = -H*k0*exp(-E/(R*Tee))/(RHO*CP)
a22 = -F/V - UA/(V*RHO*CP) - H*k0*CAee/(RHO*CP)*exp(-E/(R*Tee))*E/(R*Tee^2) 
b11 = 0
b12 = UA/(V*RHO*CP)

// Sistema no lineal
function dxdt = SNL(x)
    // Variables de estado
    CA = x(1)
    T  = x(2)
    // Variables de entrada
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
u = TJ;
J = numderivative(SNL,[xee;u])

// Sistema lineal
A = J(:,1:2)
B = J(:,3)
C = [0,1]
SL = syslin('c',A,B,C)
