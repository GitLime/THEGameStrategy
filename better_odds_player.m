function [ player ] = better_odds_player()
%A player that make decisions based on the strength of its current hand,
%not considering future cards or what an opponenet could have
player = struct('name', 'better odds','pdf', 'player_pdf', 'decision', @better_odds_decision, 'parameters', {0});
end

