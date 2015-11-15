%clear all; clc;

global_info.blinds = [10 20];
global_info.player_bets = [40 40 0 0];
global_info.min_raise = 40;
global_info.has_folded = [0 0 0 0];
player_nr = 3;
color = 70;

min_bet = global_info.blinds(2);
call_amount = max(global_info.player_bets);
play = global_info.player_bets(player_nr);

if call_amount == 0 % can check, or bet
    if color < min_bet;
        play = 0;  %CHECK
    else;
        play = color; 
        global_info.min_raise = play;
    end %BET
else %can fold, call, or raise
    if color < call_amount; %FOLD
        global_info.has_folded(player_nr) = 1;
    elseif color < call_amount + global_info.min_raise; %CALL
        play = call_amount;
    else %RAISE
        play = color;
        global_info.min_raise = play - call_amount;
    end
end
global_info.player_bets(player_nr) = play
play