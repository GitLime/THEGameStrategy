function [play_amount] = better_odds_decision(hand, table, player_params)
%Will play coresponding to the strength of the current 2 or 5 card hand,
%disregarding all other info. 

global global_info;
blind = 20;
strength = hand_strength_consider_table(sum(global_info.has_folded==0), hand, table);
play_amount = round(strength * blind * 10);

toCall = max(global_info.player_bets) - global_info.player_bets(global_info.player_nr);
pot = global_info.pot + sum(global_info.player_bets);
expected_win = strength*pot;

if and(play_amount < max(global_info.player_bets), expected_win > toCall)
    play_amount = max(global_info.player_bets); %CALL
end
end

