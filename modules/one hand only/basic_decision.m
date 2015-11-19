function [play_amount] = basic_decision(hand, table)
%Will play coresponding to the strength of the current 2 or 5 card hand,
%disregarding all other info. 
blind = 20;
strength = smpl_hand_strength(hand, table);
%if isempty(table)
    %2 card hand
%   	play_amount = strength * blind;
%    return
%end 
%5 card hand
play_amount = round(strength * blind * 10);

end

