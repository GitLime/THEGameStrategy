function [play_amount] = basic_expect_decision(hand, table, params)
%Will play corresponding to the strength of the current 2 or 5 card hand.
%Before folding it will calculate the expected winning of a call and will
%call if this value is greater than the call amount

global global_info;
blind = 20;
strength = smpl_hand_strength(hand, table);
play_amount = round(strength * blind * 10);

toCall = max(global_info.player_bets) - global_info.player_bets(global_info.player_nr);
pot = global_info.pot + sum(global_info.player_bets);
expected_win = strength*pot;

if and(play_amount < max(global_info.player_bets), expected_win > toCall)
    play_amount = max(global_info.player_bets); %CALL
end;
end

