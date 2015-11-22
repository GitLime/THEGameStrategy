function [ player ] = basic_concord_player()
%A player that make decisions based on the strength of its current hand,
%and that sometimes makes calls in hopes of getting a better hand after
%cards are put on the table
global global_info
player = struct('name', 'concord', 'pdf', 'player_pdf', 'decision', @basic_concord_decision, 'parameters', 0);
end

