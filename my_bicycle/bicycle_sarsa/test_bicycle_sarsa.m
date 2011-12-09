global graphica;
graphica = false;

% init parallel
if (matlabpool('size') == 0), matlabpool('open'); end

% test params
test_count = 4;
episode_count = 10;


lcurves = zeros(test_count, episode_count);
parfor i = 1:test_count
    lcurves(i,:) = bicycle_sarsa(episode_count);
    disp(max(lcurves(i,:)));
end
plot(sum(lcurves)/test_count);
save('test_sarsa_complete.mat','lcurves');