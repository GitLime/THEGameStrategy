function end_hand()
global global_info;

if sum(global_info.has_folded) == global_info.n_players - 1
    winner = find(global_info.has_folded == 0);
    global_info.player_chips(winner) = global_info.player_chips(winner) + global_info.pot;
else
    hands = [];
    not_folded = find(global_info.has_folded == 0)
    for player_nr = not_folded;
        place = get_place(strcat('pP', num2str(player_nr), 'Cards'));
        banks = place.token_bank;
        hand = [banks(1).color banks(2).color];
        hands = [hands hand];
    end
    
    place = get_place(strcat('pTableCards'));
    banks = place.token_bank;
    table = [banks(1).color banks(2).color banks(3).color banks(4).color banks(5).color];
    hands = [hands table];
    
    winners = not_folded(find_winners( hands, table ));
    for winner = winners
        global_info.player_chips(winner) = global_info.player_chips(winner) + round(global_info.pot/length(winners));
    end
end

%for next hand
global_info.cards_dealt_in_state = [8,3,1,1];
global_info.cards_dealt_to_table = [0,3,1,1];
global_info.card_dealt_counter = global_info.n_players * 2;
global_info.small_blind_player = mod(global_info.small_blind_player,4)+1;
global_info.cards_returned = 0;
global_info.shuffled_deck = global_info.new_deck(randperm(52));
global_info.has_folded = zeros(1, global_info.n_players);
disp(global_info.pot)


global_info.pot = 0;

end

