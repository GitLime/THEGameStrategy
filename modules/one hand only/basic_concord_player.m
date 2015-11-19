function [ player ] = basic_concord_player()
%A player that make decisions based on the strength of its current hand,
%not considering future cards or what an opponenet could have
player = struct('pdf', 'smpl_player_pdf', 'decision', @basic_concord_decision, 'parameters', {0});
end

