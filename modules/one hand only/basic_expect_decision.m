function [play_amount] = basic_expect_decision(hand, table)

global global_info;

%Will play coresponding to the strength of the current 2 or 5 card hand,
%disregarding all other info. 
blind = 20;
strength = smpl_hand_strength(hand, table);
play_amount = round(strength * blind * 10);


pot = global_info.pot + sum(global_info.player_bets);
expected_win = strength*pot;

play_amount = expected_win;

end

