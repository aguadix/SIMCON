clear; clc;
// P201.sce
exec D:\SIMCON\P1\P101.sce;
s = %s;

// Sistema de primer orden
G = B/(s-A)

// Sistema de segundo orden
//G = (b21*s+a21*b11-a11*b21)/(s^2-(a11+a22)*s+a11*a22-a12*a21) // y = x2

// Función de Scilab
G = ss2tf(SL)
