function [ player ] = basic_player()
player = struct('pdf', 'smpl_player_pdf', 'decision', @basic_decision, 'parameters', {0});
%A player that make decisions based on the strength of its current hand,
%not considering future cards or what an opponenet could have
end

