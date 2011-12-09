%clear all
clc
clf;

% % global TxtEpisode TxtSteps goal f1 f2 grafica
% global grafica; 
% 
% f1 = subplot(2,1,1);
% box off
% 
% f2 = subplot(2,1,2);
% grafica = false;
% 
% P2 = ['setgrafica();'];
% set(gcf,'name','RPI with a Scara Manipulator Robot');
% set(gcf,'Color','w')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% grid off                        % turns on grid
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set(gco,'BackingStore','off')  % for realtime inverse kinematics
% %set(gco,'Units','data')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rep = 1;

epi = [5:10:500];

max_steps = 50;

discount = 0.8;

success_steps = 10000;

howmany = 1;

basis = 'bicycle_basis_eigen';

for r = 1:rep
    xpoints = [];
    ypoints = [];
    
    for i = 1:length(epi)
        if i == 1
            numepi = epi(i);
            sample = [];
        else
            numepi = epi(i) - epi(i-1);
        end
        
        cnt = 0;
        att = 0;
        
        while (cnt < numepi)
            if i == 1
                new_samples = collect_samples('bicycle', 1, max_steps);
            else if flag == true
                    new_samples = collect_samples('bicycle', 1, best_steps, best_policy);
                else new_samples = collect_samples('bicycle', 1, max_steps);
                end;
            end;
            
            bsamples = cat(1, new_samples.state);
            
            sample = [sample new_samples];
            cnt = cnt + 1;
            clear new_samples;
        end;
        
        [allpol1(r,i), alllspipol1, sample] = rpi_learn('bicycle', 50, 10^-5, sample, ...
            0,0,discount,basis,[],bicycle_initialize_policy(0.0, discount, basis), ...
            struct('rpi_initializebasis_opts',...
            struct('SizeRandomSubset',1000),'rpi_basis_opts',...
            struct('NormalizationType','beltrami','Type','nn',...
            'BlockSize',10,'MaxEigenVals',20,'Delta',0.5,'DownsampleDelta',...
            0.1,'NNsymm','ave','kNN', 5, 'Rescaling', ...
            [1, 0.2, 5, 1, 0.2, 1, 0, 0, 0, 0, 0])));

        [allprob1(r,i), ignore, ignore, allstep1(r,i)] = bicycle_evalpol(allpol1(r,i), ...
            howmany, success_steps);
        
        if i == 1
            best_policy = allpol1(r,i);
            best_steps = allstep1(r,i);
        else if allstep1(r,i) > best_steps
                flag = true;
                best_steps = allstep1(r,i);
                best_policy = allpol1(r,i);
                %bicycle_plot_trajectory(best_policy, best_steps, 1);
            else flag = false;
            end;
        end;
        
        xpoints(i) = i-1;
        ypoints(i) = allstep1(r,i);     
%         figure(1); subplot(3,1,3); 
%         plot(xpoints, ypoints, 'LineWidth', 2);
%         title(['RPI Learning Episode: ', int2str(i), ' Best: ', int2str(best_steps), ' Sampes: ', int2str(length(sample))], 'FontSize', 14)
%         xlabel('Episodes')
%         ylabel('Steps')
       drawnow
        
    end;
end;
            