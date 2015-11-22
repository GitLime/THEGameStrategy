function [play_amount] = primitive_decision(hand, table, player_params)
%Will play corresponding to the its odds of winning calculated based on 
%number of players left in hand

global global_info

blind = 20;
strength = 1/sum(1 - global_info.has_folded);
play_amount = round(strength * blind * 10);

end
