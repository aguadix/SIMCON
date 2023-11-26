// P201.sce
s = syslin('c',%s,1);

// Sistema de primer orden
// G = B/(s-A)

// Sistema de segundo orden (y = x2)   
G = (b21*s+a21*b11-a11*b21)/(s^2-(a11+a22)*s+a11*a22-a12*a21)
G = (B(2,1)*s+A(2,1)*B(1,1)-A(1,1)*B(2,1))/(s^2-(A(1,1)+A(2,2))*s+A(1,1)*A(2,2)-A(1,2)*A(2,1))

// Función de Scilab
G = ss2tf(SL) 
