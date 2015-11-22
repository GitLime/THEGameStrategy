function [play_amount] = bluffing_decision(hand, table, params)

global global_info;

%Will play coresponding to the strength of the current 2 or 5 card hand,
%disregarding all other info. 
blind = 20;
p_bluff = params.p_bluff;

bluf_strength = 0;
if p_bluff > global_info.bluffs_stoc(global_info.players_turn)
    bluf_hand = {'cas', 'cad'};
    bluf_table = {'cah', 'cak', 'c2s', 'c6h', 'c9h'};
    if global_info.game_state == 1
        bluf_table = {};
    else
        bluf_table = bluf_table(1:3+global_info.game_state-2);
    end 
    bluf_strength = hand_strength_with_reads(bluf_hand, bluf_table, params.bluf_predictions);
end

strength = max(hand_strength_with_reads(hand, table, params.bluf_predictions),bluf_strength);
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

