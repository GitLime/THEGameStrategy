function [play_amount] = better_odds_decision2(hand, table, params)

global global_info;

%Will play coresponding to the strength of the current 2 or 5 card hand,
%disregarding all other info. 
blind = 20;
p_bluf = params.p_bluf;
players_in_hand = sum(global_info.has_folded == 0);

bluf_strength = 0;
if p_bluf > global_info.blufs_stoc(global_info.players_turn)
    bluf_hand = {'cqs', 'cks'};
    bluf_table = {'cqd', 'ckk', 'c2s', 'c6h', 'c9h'};
    if global_info.game_state == 1
        bluf_table = {};
    else
        bluf_table = bluf_table(1:3+global_info.game_state-2);
    end 
    bluf_strength = hand_strength_with_reads(bluf_hand, bluf_table, params.bluf_predictions);
    %bluf_strength = hand_strength_consider_table(players_in_hand, bluf_hand, bluf_table);
end



players_in_hand = sum(global_info.has_folded == 0);

strength = max(hand_strength_with_reads(hand, table, params.bluf_predictions),bluf_strength);
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

