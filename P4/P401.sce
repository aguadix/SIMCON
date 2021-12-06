clear; clc; 
// P401.sce
s = syslin('c',%s,1);

// Proceso de segundo orden sobreamortiguado
Kp = 1; Tp1 = 10; Tp2 = 5; Gp = Kp/((Tp1*s+1)*(Tp2*s+1)) 

// Válvula de primer orden
Kv = 0.5; Tv = 1; Gv = Kv/(Tv*s+1) 

// Medida ideal
Gm = 1 

// Controlador
// Kc = 12; P = Kc; I = 0; D = 0;  // P
// Kc = 12; Ti = 16; P = Kc; I = Kc/Ti; D = 0; // PI
Kc = 12; Ti = 16; Td = 2.3; P = Kc; I = Kc/Ti; D = Kc*Td; // PID
Gc = P + I/s + D*s 

// Función de transferencia en lazo cerrado (servomecanismo)
Gcl = Gc*Gv*Gp/(1+Gm*Gc*Gv*Gp)

// Respuesta temporal a escalón
dt = 0.01; tfin = 120; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);

scf(1); clf(1); 
plot(t,y); 
xgrid; xtitle('Respuesta temporal a escalón', 't', 'y');

// Tiempo de pico
[yp,indexp] = max(y)
tp = t(indexp)
plot(tp,yp,'ro');

// Error
e = 1 - y;
offset = e($)

scf(2); clf(2); 
plot(t,e); 
xgrid; xtitle('Error', 't', 'e');

// Integral del error
intedt(1) = 0;
for i = 2:length(t)
    intedt(i) = intedt(i-1) + dt*(e(i-1)+e(i))/2; 
end

// Derivada del error
dedt = diff(e)/dt;

scf(3); clf(3); 
subplot(3,1,1); plot(t,P*e); xgrid; xtitle('Acciones de control','','P*e');
subplot(3,1,2); plot(t,I*intedt); xgrid; xtitle('','','I*intedt'); 
subplot(3,1,3); plot(t(1:$-1),D*dedt); xgrid; xtitle('','t','D*dedt');
