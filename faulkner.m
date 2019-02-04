clear all; close all; clc;
%% Faulkner - Skan solution by shooting method

% Note that the paramter T in the code is \eta
% parameter Y in the code is solution f,dfdeta and d2f/deta2

global U;
global nu;
global n;


U = 1;                          % U infinity
nu = 1e-6;                      % Kinematic viscosity    
n = 0.9;                        % Order of the equation    

a0=1;                           % Coefficient of the equation    
x1=0;                           % First point on the wedge
x2=10;                          % Second point

tend = 10;                      % Last eta value . If Y has not saturated increase tend.
tspan = [0 tend];
alpha = 0.7;                    % Initial guess for d2f/deta2. Be careful in putting the right guess as solution may blow up.
dalpha = 0.1;                   % parameter for shooting method

a=0;                            % Dummy variable 


for i=1:1000 

    if a~=1
        
    y0=[0;0;alpha];

    [T,Y] = ode45('rhs_faulkner',tspan,y0);
    
    
    % Shooting method by bisection 
    % Tolerence is set to be 1e-6
    
    if Y(end,2)-1>1e-6
        
        alpha = alpha - dalpha;
        
    elseif Y(end,2)-1<1e-6
            
         alpha = alpha + dalpha;
        dalpha = dalpha/2;
        
    else
        
        a=1;
        
    end
    
    end
end
%%
% Symbolic variables for numerical integration

syms x f  delta theta F delta1 delta2

si=size(Y);                             % Computes size of the solution variable
s=si(1);
index=find(Y(:,2)>=0.5,1,'first');      % Finds where U/Uinf is 1 for the first time
delta=T(index);                         % Finds eta at that index
delta1=delta*(nu*x/(a0*x^n))^0.5;       % Comes from the equation
%%
% Computing boundary layer thickness, momentum thickness and displacement
% thickness

z=[0:(delta/(s-1)):delta];
g=trapz(z,(1-Y(:,2)));
h=trapz(z,(Y(:,2)-Y(:,2).*Y(:,2)));
delta2=g*(a0*x^n/nu*x)^0.5;
theta=h*(a0*x^n/nu*x)^0.5;

%%

% Plotting

 X=linspace(x1,x2);
   Delta1=subs(delta1,x,X);
    Delta2=subs(delta2,x,X);
    Theta3=subs(theta,x,X);
    
    

%%
    plot(T,Y(:,2))
    
    figure(1)
    plot(T,Y(:,2));
    xlabel \eta;
    ylabel u/U_\infty;
    title('u/U_\infty vs \eta');
        
    %%
    
    figure(2);
    plot(X,Delta1);
    xlabel x;
    ylabel \delta;
    title('\delta vs x');
    
    %%
    figure(3)
    plot(X,Delta2);
    xlabel x;
    ylabel \delta^*;
    title('\delta^* vs x');
    %%
    figure(4)
    plot(X,Theta3);
    xlabel x;
    ylabel \theta;
    title('\theta vs x');
    %%
    % Displays corrected df2/deta2
    alpha
