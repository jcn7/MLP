function  [nexts, reward, endsim] = bicycle_simulator(state, action)

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
% [nextstate, reward, endsim] = bicycle_simulator(state, action)
%
% A simulator for the bicycle domain.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  persistent mapaction;
  persistent maxnoise
  
  
  if (nargin<1) 
  
    % Initialize
    
    [nexts, reward, endsim] = bicycle;
    
    return
  
    
  elseif nargin<2
    
    % Set state
    
    [nexts, reward, endsim] = bicycle(state);
    
    return
    
  end
  
  if isempty(maxnoise)
    [unused, mapaction] = bicycle_actions;
    maxnoise = 0.02;  
  end
  
  myaction = mapaction(action,:);
  
    
  [nexts, reward, endsim] = bicycle(state, myaction, maxnoise);
  
  
  return
  
