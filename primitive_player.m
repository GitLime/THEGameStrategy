function [ player ] = primitive_player()
%A player that calculates its chance of winning based on the number of
%players left in the hand, not considering any cards or bets
player = struct('name','primitive','pdf', 'player_pdf', 'decision', @primitive_decision, 'parameters', {0});
end

