function [ player ] = better_odds_player2(p_bluf, bluf_predictions)
%A player that make decisions based on the strength of its current hand,
%not considering future cards or what an opponenet could have
params.p_bluf = p_bluf;
params.bluf_predictions = bluf_predictions;
player = struct('pdf', 'smpl_player_pdf', 'decision', @better_odds_decision2, 'parameters', params);
end

