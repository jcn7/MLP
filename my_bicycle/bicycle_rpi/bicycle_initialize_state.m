function initial_state = bicycle_initialize_state(simulator)
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2000-2002 
%
% Michail G. Lagoudakis (mgl@cs.duke.edu)
% Ronald Parr (parr@cs.duke.edu)
%
% Department of Computer Science
% Box 90129
% Duke University
% Durham, NC 27708
% 
%
% initial_state = bicycle_initialize_state(simulator)
%
% Initializes the state of the bicycle
% It picks one state close to the equilibrium state by adding
% uniformly random noise to the equilibrium state
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  initial_state = bicycle_simulator;
  
  %noise = 2 * rand(1,8) - 1;
  %noisy_state = [pi/100  0.1  pi/1200  0.05  0  pi  0  0] .* noise;
  
  noise = 2 * rand(1,6) - 1;
  noisy_state = [pi/100  0.1  pi/1200  0.05  0  pi] .* noise;
  
%   fprintf('\n starting from initial state: '); 
%   disp(noisy_state); 
  
  initial_state(1:length(noisy_state)) = noisy_state;
  
  return
