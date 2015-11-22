function [play_amount] = basic_concord_decision(hand, table, params)

global global_info;

%Will play coresponding to the strength of the current 2 or 5 card hand,
%disregarding all other info. 
blind = 20;
strength = smpl_hand_strength(hand, table);
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

    pot_size = ((toCall+global_info.pot)/(global_info.max_bet*5*players_left));

    buffer = 0.5;
    %Willing to call up to
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
