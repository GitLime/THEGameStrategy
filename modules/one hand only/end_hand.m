function end_hand()
global global_info;

if sum(global_info.has_folded) == global_info.n_players - 1
    winner = find(global_info.has_folded == 0);
    global_info.player_chips(winner) = global_info.player_chips(winner) + global_info.pot;
    theprint(['player ' num2str(winner) ' won ' num2str(global_info.pot)]);
else
    not_folded = 1 - global_info.has_folded;
    hands = [];
    for player_nr = 1:global_info.n_players;
        if not_folded(player_nr)
            place = get_place(strcat('pP', num2str(player_nr), 'Cards'));
            banks = place.token_bank;
            hand = [banks(1).color banks(2).color]
        else
            hand = [{'000'}, {'000'}]
        end
        
        hands = [hands; hand];
    end
    
    
    
    global_info.hands = hands;
    
    place = get_place(strcat('pTable'));
    banks = place.token_bank;
    table = [banks(1).color banks(2).color banks(3).color banks(4).color banks(5).color];
    
    winners = find_winners( hands, table )
    for winner = winners
        global_info.player_chips(winner) = global_info.player_chips(winner) + round(global_info.pot/length(winners));
        theprint(['player ' num2str(winner) ' won ' num2str(round(global_info.pot/length(winners)))]);
    end
end

end

