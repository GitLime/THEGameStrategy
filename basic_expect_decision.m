function [play_amount] = basic_expect_decision(hand, table, params)

global global_info;

%Will play coresponding to the strength of the current 2 or 5 card hand.
%Before folding it will calculate the expected winnning of a call and will
%call if this value is greater than the call amount

blind = 20;
strength = smpl_hand_strength(hand, table);
play_amount = round(strength * blind * 10);


toCall = max(global_info.player_bets) - global_info.player_bets(global_info.player_nr);

pot = global_info.pot + sum(global_info.player_bets);
expected_win = strength*pot;

if and(play_amount < max(global_info.player_bets), expected_win > toCall)
    %theprint('EXPECTED TO WIN MORE');
    %theprint(expected_win);
    play_amount = max(global_info.player_bets); %CALL
end;
end

