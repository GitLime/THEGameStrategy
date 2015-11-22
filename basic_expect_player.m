function [ player ] = basic_expect_player()
%A player that make decisions based on the strength of its current hand,
%and makes calls if the expected winnings of the call if positive
player = struct('name', 'expect', 'pdf', 'player_pdf', 'decision', @basic_expect_decision, 'parameters', {0});
end

