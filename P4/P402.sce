clear; clc;
// P402.sce
s = syslin('c',%s,1);

// Proceso de segundo orden críticamente amortiguado (variable manipulada)
Kp = 1; Tp = 10; Gp = Kp/(Tp*s+1)^2 

// Proceso de segundo orden críticamente amortiguado (perturbación)
Kd = 2; Gd = Kd/(Tp*s+1)^2 

// Válvula de primer orden
Kv = 1; Tv = 1; Gv = Kv/(Tv*s+1) 

// Medida ideal
Gm = 1 

// Controlador
// Kc = 9.0; P = Kc; I = 0; D = 0;  // P
// Kc = 9.0; Ti = 2*8.5; P = Kc; I = Kc/Ti; D = 0; // PI
Kc = 9.0; Ti = 2*8.5; Td = 6.4; P = Kc; I = Kc/Ti; D = Kc*Td; // PID
Gc = P + I/s + D*s 

// Función de transferencia en lazo cerrado (regulador)
Gcl = Gd/(1+Gm*Gc*Gv*Gp)

// Respuesta temporal a escalón
dt = 0.01; tfin = 250; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);

scf(1); clf(1); 
plot(t,y); 
xgrid; xlabel('t'); ylabel('y');

// Tiempo de pico
[yp,indexp] = max(y)
tp = t(indexp)
plot(tp,yp,'ro');

// Error
e = 0 - y;
offset = e($)

scf(2); clf(2); 
plot(t,e); 
xgrid; xlabel('t'); ylabel('e');

// Integral del error
edt(1) = 0;
edt(2:length(t)) = (e(1:$-1)+e(2:$))/2*dt;
intedt = cumsum(edt);

// Derivada del error
dedt = diff(e)/dt;

scf(3); clf(3); 
subplot(3,1,1); plot(t,P*e); xgrid; ylabel('P*e');
subplot(3,1,2); plot(t,I*intedt); xgrid; ylabel('I*intedt');
subplot(3,1,3); plot(t(1:$-1),D*dedt); xgrid; xlabel('t'); ylabel('D*dedt');
