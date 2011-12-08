function [actions, mapaction] = bicycle_actions()
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2000-2002 
%
% Michail G. Lagoudakis (mgl@cs.duke.edu)
% Ronald Parr (parr@cs.duke.edu)
%
% Department of Computer Science
% Box 90129
% Duke University, NC 27708
% 
%
% [actions, mapaction] = bicycle_actions()
%
% Returns the total number of actions in the bicycle domain and a
% table (mapaction) that lists the values for torque and
% distplacement for each action explicitly
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  
  T = 2;      % Torque 
  d = 0.02;   % Displacement
    
  %     mapaction = [ 
  %         -T 0;  
  %         0  0; 
  %         +T 0 
  %     ];
  
  
  mapaction = [ 
      0 -d;  
      0  0; 
      0 +d;
     +T  0;
     -T  0
	      ];
  
  %     mapaction = [ 
  %         -T   0;
  %         0  -d;
  %         0   0;
  %         0  +d;
  %         +T   0;
  %     ];
  
  
  %         mapaction = [ 
  %             -T  -d;
  %             -T   0;
  %             -T  +d;
  %              0  -d;
  %              0   0;
  %              0  +d;
  %             +T  -d;
  %             +T   0;
  %             +T  +d
  %         ];
  
  actions = size(mapaction,1);
  
  return
  
