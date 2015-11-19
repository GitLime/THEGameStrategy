function [play_amount] = basic_expect_decision(hand, table)

global global_info;

%Will play coresponding to the strength of the current 2 or 5 card hand,
%disregarding all other info. 
blind = 20;
strength = smpl_hand_strength(hand, table);
play_amount = round(strength * blind * 10);

toCall = 0;

for i = 1:global_info.n_players
    bet = global_info.player_bets(i);
    if bet > toCall
        toCall = bet;
    end;
end;

pot = global_info.pot + toCall;
expected_win = strength*pot;

if and(play_amount < toCall, expected_win > toCall)
    theprint('EXPECTED TO WIN MORE');
    theprint(expected_win);
    play_amount = toCall;
end;

end

