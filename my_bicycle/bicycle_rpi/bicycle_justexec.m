function [steps, totdrew, toturew, goal, crash, closestdistance, ...
	  stepstogoal] = bicycle_justexec(initial_state, policy, maxsteps)

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
% [steps, totdrew, toturew, goal, crash, closestdistance, ...
%	  stepstogoal] = bicycle_justexec(initial_state, policy, maxsteps)
%
% Executes one episode (of at most "maxsteps" steps) on the
% bicycle starting at the "initial_state" and using the "policy"
% to select actions.
%
% It returns the total number of steps, the total discounted and
% undiscounted reward collected during the episode, an indication that
% the goal was reached, an indication that a crash occured, the
% closest distance to the goal, and the number of steps for reaching
% the goal the first time.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 

  %%% Initialize the random number generator to a random state
  rand('state', sum(100*clock));
  
  
  %%% Set initial state
  state = bicycle_simulator(initial_state);

  
  %%% Initialize variables
  totdrew = 0;
  toturew = 0;
  steps = 0;
  goal = 0;
  crash = 0;
  %closestdistance = state(7);
  closestdistance = state(10);
  stepstogoal = inf;
  mydiscount = 1;
  
  %%% Run the episode
  while ( (steps < maxsteps) & (~crash) )
    
  %  closestdistance = min( closestdistance, state(7) );
    closestdistance = min( closestdistance, state(10) );
    
%    if state(7)==0 & stepstogoal==inf
    if state(10)==0 & stepstogoal==inf
      goal = 1;
      stepstogoal = steps;
    end
    
    steps = steps + 1;
    
    %%% Select action 
    action = policy_function(policy, state);
    
    %%% Simulate
    [state, reward, crash] = bicycle_simulator(state, action);
    
    %%% Update the total reward(s)
    totdrew = totdrew + mydiscount * reward;
    mydiscount = mydiscount * policy.discount;
    toturew = toturew + reward;
    
    %%% Continue
    %state = nextstate;
    
  end
  
  
  closestdistance = round(closestdistance*100)/100;
  %if stepstogoal~=inf
  %  stepstogoal = round(stepstogoal*100)/100;
  %end


  
  
  return
  
