function [play_amount] = basic_concord_decision(hand, table, params)
%Makes a play based on its odds, but sometimes calls beyond this play 
%amount as well

global global_info;

blind = 20;
strength = smpl_hand_strength(hand, table);

%Highest bet to call
toCall = max(global_info.player_bets);
hasFolded = sum(global_info.has_folded);

play_amount = round(strength * blind * 10);

%Deciding to call if bets are higher than hand strength.
if play_amount < toCall
    init_amount = play_amount;
    players_left = global_info.n_players-hasFolded;

    pot_size = ((toCall+global_info.pot)/(global_info.max_bet*5*players_left));
    buffer = 0.5;
    if round(init_amount*(1+buffer+pot_size)) >= toCall
            play_amount = toCall;
    end;
end;
end
