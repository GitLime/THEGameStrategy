function [color] = strategy_smpl(value, player_nr)
    global global_info;
    
    if strcmp(global_info.player_bets(player_nr), num2str(-1))
        color = -1;
        return
    %elseif value == global_info.player_bets(player_nr),
    %    global_info.end_round = 1;
    end
    
    if global_info.player_bets(player_nr) > 500
        color = global_info.player_bets(player_nr);
    else
        color = global_info.player_bets(player_nr)+200;
    end;