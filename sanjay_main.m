close all; clear all; clc;
%%

n=500;                          % Number of grid points
eta = linspace(0,20,n+1);         % Linear mesh of X into n+1 points


%%
solinit = bvpinit(linspace(0,20,300),'sanjay_sample_func');      % initializing the solver

sol = bvp4c('sanjay_blasius_rhs','sanjay_blasius_bc',solinit);

% Retrieving data sol structure
Y = deval(sol,eta);

%% Retrieving original parameters from f, g, and h

% Free stream velocity 
Uinf = 0.01;
% Kinematic viscosity
nu = 1e-5;
% Surface temperature
Ts = 500;
% Ambient temperature
Tinf = 300;

x0 = 1;
y0 = eta*sqrt((nu*x0)/Uinf);

U = Uinf*Y(2,:);
% V = 0.5*sqrt(Uinf*nu/x0)*(eta.*Y(2,:)-Y(1,:));
 T = Ts + (Tinf-Ts)*Y(2,:);
Delta = 4.91*sqrt(eta*nu/Uinf);

%% Plotting 

X_print = [];
Y_print = [];
V_print = [];
U_print = [];
T_print = [];

figure(1)
plot(eta,Y(2,:));
title(' df/d\eta vs \eta')

figure(2)
plot(eta,Y(3,:));
title(' d^2f/d\eta^2 vs \eta')

figure(3)
for x0=1:10
    
    y0 = eta*sqrt((nu*x0)/Uinf);
    Y_print = [Y_print y0];
    U_print = [U_print U];
    plot(U,y0); hold on;

    drawnow;
end
legend('show');
title(' Y vs U ' );

figure(4)
for x0=1:10
    
    V = 0.5*sqrt(Uinf*nu/x0)*(eta.*Y(2,:)-Y(1,:));
    V_print = [V_print V];
    y0 = eta*sqrt((nu*x0)/Uinf);
    plot(V,y0); hold on;
    drawnow;

end
legend('show');
title(' Y vs V' );

figure(5)
for x0=1:10
    
    y0 = eta*sqrt((nu*x0)/Uinf);
    T_print = [T_print T];
    X_print = [X_print x0*ones(1,n+1)];
    plot(T,y0); hold on;
    drawnow;

end
legend('show');
title(' Y vs T' );

figure(6)
plot(eta,Delta);
title('Boundary layer thickness');

OUT = [eta' Y(2,:)']

%% Writing array into file

% A = [X_print; Y_print; U_print; V_print; T_print];
% 
% fileID = fopen('sanjay_blasius_output.txt','w');
% fprintf(fileID,'%6s %12s %12s %12s %12s\r\n','x','y','U','V','T');
% fprintf(fileID,'%6.2f %12.8f %12.8f %12.8f %12.8f\r\n',A);
% fclose(fileID);

 save blassius_profile.dat OUT -ASCII

