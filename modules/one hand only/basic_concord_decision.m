function [play_amount] = basic_concord_decision(hand, table, params)

global global_info;

p_bluf = params.p_bluf;
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
end

%Will play coresponding to the strength of the current 2 or 5 card hand,
%disregarding all other info. 
blind = 20;
strength = max(hand_strength_with_reads(hand, table, params.bluf_predictions), bluf_strength);

% % divide by sum blufs
% in_game = ones(1, global_info.n_players) - global_info.has_folded;
% strength = strength / sum(params.bluf_predictions(in_game==1));
% % multiply by players
% strength = strength * sum(in_game);



%if isempty(table)
    %2 card hand
%   	play_amount = strength * blind*10;
%    return
%end 

%5 card hand
%Max bet = 2000?

%Highest bet to call
toCall = 0;
hasFolded = 0;
for i = 1:global_info.n_players
    bet = global_info.player_bets(i);
    if bet > toCall
        toCall = bet;
    end;
    if global_info.has_folded(i)
        hasFolded = hasFolded+1;
    end;
end;

play_amount = round(strength * blind * 10);

%Deciding to call if bets are higher than hand strength.
if play_amount < toCall
    init_amount = play_amount;
    %disp('Initial amount');
    %disp(init_amount);
    players_left = global_info.n_players-hasFolded;
    pot = global_info.pot + sum(global_info.player_bets);
    pot_size = pot/(global_info.max_chips_to_play*global_info.n_players);
    %disp('Willing to call up to');
    buffer = 0.5;
    %disp(round(init_amount*(1+buffer+pot_size)));
    if round(init_amount*(1+buffer+pot_size)) >= toCall
            play_amount = toCall;
    end;
end;

if play_amount > global_info.max_bet
    play_amount = 400;
end;

%play_amount = toCall;
%play_amount = round(strength * blind * 10);

end

