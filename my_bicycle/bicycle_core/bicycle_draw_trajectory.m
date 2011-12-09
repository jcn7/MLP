function bicycle_draw_trajectory( xpos, ypos )
%BICYCLE_DRAW_TRAJECTORY
    % draw the trejectory of the bike, to be moved into seperate function
	% maybe be more fancy with the ploting.
    global graphica;
    if graphica
        line(xpos, ypos);
        title('trajectory');
        drawnow
    end
end