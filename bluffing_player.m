function [ player ] = bluffing_player(p_bluff, bluff_predictions)
%%Behave similarly to a better odd player but makes bluffs a given 
%percentage of the time
params.p_bluff = p_bluff;
params.bluf_predictions = bluff_predictions;
player = struct('name',['bluffing (' num2str(p_bluff*100) '%)'], 'pdf', 'player_pdf', 'decision', @bluffing_decision, 'parameters', params);
end

