function [ player ] = better_odds_player()
%A player that behaves the same way as a basic expect player, but is 
%better at calculate its winning ods
player = struct('name','better odds','pdf', 'player_pdf', 'decision', @better_odds_decision, 'parameters', {0});
end