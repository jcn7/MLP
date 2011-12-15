
function [nexts, reward, endsim] = cartpole_simulator(state, action); 

global grafica; 

% full 4D Cart Pole problem

%  Cart_Pole:  Takes an action (0 or 1) and the current values of the
%  four state variables and updates their values by estimating the state
%  TAU seconds later.

  if nargin<1
  
    % Initialize
  
    nexts = [ 0 0 0 0.01];
    reward = 0;
    endsim = 0;
    
    return
    
  elseif nargin<2
    
    % Set state
    
    nexts = state;
    reward = 0;
    endsim = 0;
    return
    
  end
  


% Parameters for simulation
x          = state(1);
x_dot      = state(2);
theta      = state(3);
theta_dot  = state(4);


g               = 9.8;      %Gravity
Mass_Cart       = 1.0;      %Mass of the cart is assumed to be 1Kg
Mass_Pole       = 0.1;      %Mass of the pole is assumed to be 0.1Kg
Total_Mass      = Mass_Cart + Mass_Pole;
Length          = 0.5;      %Half of the length of the pole 
PoleMass_Length = Mass_Pole * Length;
Force_Mag       = 10.0;
Tau             = 0.02;     %Time interval for updating the values
Fourthirds      = 4.0/3.0;

% add some graphics 

acts = action_ranges; 

act = acts(action); 

%if action==1
%    act = -1; 
%elseif action==2
%    act = 0; 
%else act = 1; 
%end; 

if grafica==true
    display_cartpole(state,act);
end; 

force = act * Force_Mag;  

temp     = (force + PoleMass_Length * theta_dot * theta_dot * sin(theta)) / Total_Mass;
thetaacc = (g * sin(theta) - cos(theta) * temp) / (Length * (Fourthirds - Mass_Pole * cos(theta) * cos(theta) / Total_Mass));
xacc     = temp - PoleMass_Length * thetaacc * cos(theta) / Total_Mass;
 
% Update the four state variables, using Euler's method.
x         = x + Tau * x_dot;
x_dot     = x_dot + Tau * xacc;
theta     = theta + Tau * theta_dot;
theta_dot = theta_dot+Tau*thetaacc;

nexts = [x x_dot theta theta_dot];

% reward and end of episode calculations

reward = 10 - 10*abs(10*theta)^2 - 5*abs(x) - 10*theta_dot;
endsim = false;

twelve_degrees     = deg2rad(12); % 12º
fourtyfive_degrees = deg2rad(45); % 45º
%if (x < -4.0 | x > 4.0  | theta < -twelve_degrees | theta > twelve_degrees)          
if (x < -4.0 | x > 4.0  | theta < -fourtyfive_degrees | theta > fourtyfive_degrees)          
    reward = -10000 - 50*abs(x) - 100*abs(theta);     
    endsim = true;
end

return; 
