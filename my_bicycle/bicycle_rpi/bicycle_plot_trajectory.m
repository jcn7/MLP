function bicycle_plot_trajectory(pol, maxsteps, iteration)

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
% data = bicycle_test(pol, maxsteps, iteration)
%
% Testing and plotting results about a policy ("pol"). It runs one
% episode of "maxsteps" steps at most following policy "pol". It
% returns all the samples recorded in "data". 
%
% The following figures are printed for each iteration: 
%
% Figure 5: The angle to the goal over time
%
% Figure 6: The distance to the goal over time
%
% Figure 7: The trajectory(-ies) over the 2D plane 
%
% "Iteration" is an optional argument (valid range is [-1:12]). If
% provided and it is >=1 it creates 12 subplots in each figure and
% plots the data at the appropriate subplot according to the index
% "iteration". If ==0 or ==-1 it does create the subplots. All figures
% are cleared for "iteration"==1 or -1. The previous subplots are held
% while "iteration">1 or ==0.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  persistent mycolor 
  
  pol.explore=0.0;
  
  init_state = bicycle_simulator;

  [data, totdrew, toturew] = execute(init_state, 'bicycle_simulator', ...
				     pol, maxsteps);
  
  step = 1;
  range = [1:step:length(data)];

  states = cat(1, data(range).state);
  actions = cat(1, data(range).action);

%   
%   figure(5);
%   if iteration<=1, clf, end
%   if iteration>0, subplot(rows,cols,iteration), end
%   plot(range, states(:,6));
%   axis([0 maxsteps -pi +pi]);
%   if iteration==0
%     title('Angle to the goal');
%     xlabel('Steps');
%     ylabel('Angle');
%   else
%     title(['Angle (' num2str(iteration) ')']);
%   end
%   drawnow;
  
%   figure(6);
%   if iteration<=1, clf, end
%   if iteration>0, subplot(rows,cols,iteration), end
%   plot(range, states(:,7));
%   axis([0 maxsteps 0 1000]);
%   if iteration==0
%     title('Distance to the goal');
%     xlabel('Steps');
%     ylabel('Distance (m)');
%   else
%     title(['Distance to the goal (' num2str(iteration) ')']);
%   end
%   drawnow;
% 
  
%   
%   colorarray = [ 'm' 'r' 'g' 'b' 'k' 'c' 'y' 'm-.' 'r-.' 'g-.' 'b-.' ...
% 		 'k-.' 'c-.' 'y-.' 'm' 'r' 'g' 'b' 'k' 'c' 'y' 'm-.' ...
% 		 'r-.' 'g-.' 'b-.' 'k-.' 'c-.' 'y-.'];
  
  figure(1);
  
%   if isempty(mycolor), mycolor=1; end
%   if iteration<0 | iteration==1, clf, mycolor=1; end
%   if iteration>1 | iteration==0, mycolor=mycolor+1; end
  subplot(3,1,1); plot(states(:,8), states(:,9), 'r-.', 'LineWidth', 3); %, colorarray(mycolor));
  hold on;
  axis equal;
%  if iteration==0
    title('Trajectory');
    xlabel('X');
    ylabel('Y');
%  else
%    title(['Trajectory (' num2str(iteration) ')']);
%  end
  %rectangle('Position', [995 -5 10 10], 'Curvature', [1 1]);
%  rectangle('Position', [maxsteps -5 10 10], 'Curvature', [1 1]);
  drawnow;
  
  return;
