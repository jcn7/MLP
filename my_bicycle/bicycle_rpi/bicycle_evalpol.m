function [goal_prob, crash_prob, completion_prob, avesteps, avedrews, ...
	  aveclosestdistance, avestepstogoal, avesteps_ebs, minsteps, ...
	  maxsteps, avedrews_ebs, steps, drews,  urews, ...
	  aveclosestdistance_ebs, avestepstogoal_ebs] = ...
    bicycle_evalpol(pol, howmany, maxsteps)
  
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
% [goal_prob, crash_prob, completion_prob, avesteps, avedrews, ...
%	  aveclosestdistance, avestepstogoal, avesteps_ebs, minsteps, ...
%	      maxsteps, avedrews_ebs, steps, drews,  urews, ...
%	      aveclosestdistance_ebs, avestepstogoal_ebs] = ...
%	      bicycle_evalpol(pol, howmany, maxsteps)
%
% Evaluates the policy "pol" by running "howmany" episodes of
% "maxsteps" each. It then returns the statistics shown above (ebs
% stands for the 95% confidence intervals). A completed episode is
% one that reaches the maxsteps. A successful episode is one that
% reaches the goal at least once. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%   disp('Evaluating policy:');
%   disp(pol);
%   
  mytime = cputime;
  
  steps = zeros(1,howmany);
  drews = zeros(1,howmany);
  urews = zeros(1,howmany);
  
  for i=1:howmany
        
    state = bicycle_simulator;
    [steps(i), drews(i), urews(i), goal(i), crash(i), closestdistance(i), ...
     stepstogoal(i)] = bicycle_justexec(state, pol, maxsteps);
 
%      fprintf('\n Bicycle balanced for %d steps \n', steps(i));
%      fprintf(' Total discounted reward: %d \n', drews(i));
%      fprintf(' Total undiscounted reward: %d \n', urews(i));
  end
  
%   fprintf('\n');
% 
%   eval_time = cputime - mytime;
%   disp(['CPU time for evaluation : ' num2str(eval_time)]);
  
  completion_prob = length(find(steps==maxsteps)) / howmany; 
  
  avesteps = mean(steps);
  avesteps_std = std(steps,0,2);
  avesteps_ebs = 1.96 * avesteps_std ./ sqrt( length(steps) );
  
  minsteps = min(steps);
  maxsteps = max(steps); 
  
  avedrews = mean(drews);
  avedrews_std = std(drews,0,2);
  avedrews_ebs = 1.96 * avedrews_std ./ sqrt( length(drews) );
  
  goal_prob = length(find(goal==1)) / howmany; 
  
  crash_prob = length(find(crash==1)) / howmany; 
  
  aveclosestdistance = mean(closestdistance);
  aveclosestdistance_std = std(closestdistance,0,2);
  aveclosestdistance_ebs = 1.96 * aveclosestdistance_std ...
      ./ sqrt( length(closestdistance) );
  
  stepstogoal = stepstogoal(find(goal==1));
  if length(stepstogoal)>0
    avestepstogoal = mean(stepstogoal);
    avestepstogoal_std = std(stepstogoal,0,2);
    avestepstogoal_ebs = 1.96 * avestepstogoal_std ./ ...
	sqrt( length(stepstogoal) );
  else
    avestepstogoal = inf;
    avestepstogoal_ebs = 0;
  end
  
  
%   disp(['   Probability of success    : ' num2str(goal_prob)]);
%   disp(['   Probability of crash      : ' num2str(crash_prob)]);
%   disp(['   Probability of completion : ' num2str(completion_prob)]);
%   disp(['   Average number of steps   : ' num2str(avesteps) ' +/- ' ...
% 	num2str(avesteps_ebs)]);
%   disp(['   Minimum / Maximum steps   : [' num2str(minsteps) ' ' ...
% 	num2str(maxsteps) ']']);
%   disp(['   Average total d. reward   : ' num2str(avedrews) ' +/- ' ...
% 	num2str(avedrews_ebs)]);
%   disp(['   Average closest distance  : ' num2str(aveclosestdistance) ...
% 	' +/- ' num2str(aveclosestdistance_ebs)]);
%   disp(['   Average steps to the goal : ' num2str(avestepstogoal) ...
% 		    ' +/- ' num2str(avestepstogoal_ebs)]);
  
    
  return
