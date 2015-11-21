function [ player ] = basic_player()
%A player that make decisions based on the strength of its current hand,
%not considering future cards or what an opponenet could have
player = struct('name','basic','pdf', 'player_pdf', 'decision', @basic_decision, 'parameters', {0});
end

