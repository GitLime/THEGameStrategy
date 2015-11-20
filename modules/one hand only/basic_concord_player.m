function [ player ] = basic_concord_player()
%A player that make decisions based on the strength of its current hand,
%not considering future cards or what an opponenet could have

global global_info

params.p_bluf = 0;
params.bluf_prdictions = zeroes(0, global_info.n_players);
player = struct('pdf', 'smpl_player_pdf', 'decision', @basic_concord_decision, 'parameters', params);
end

