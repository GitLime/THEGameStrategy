function [ player ] = bluffing_player(p_bluff, bluff_predictions)
%A player that make decisions based on the strength of its current hand,
%not considering future cards or what an opponenet could have
params.p_bluf = p_bluff;
params.bluf_predictions = bluff_predictions;
player = struct('pdf', 'smpl_player_pdf', 'decision', @bluffing_decision, 'parameters', params);
end

