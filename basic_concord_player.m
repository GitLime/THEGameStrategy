function [ player ] = basic_concord_player()
%A player that make decisions based on the strength of its current hand,
%not considering future cards or what an opponenet could have
global global_info
player = struct('name', 'concord', 'pdf', 'player_pdf', 'decision', @basic_concord_decision, 'parameters', 0);
end

