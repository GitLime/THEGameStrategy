function [] = COMMON_POST(transition)

global global_info;

%Checking if round is ready to start
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'In')),
        theprint(['player ' num2str(player_nr) ' took cards']);
        global_info.card_dealt_counter = global_info.card_dealt_counter - 1;
        if global_info.card_dealt_counter == 0,
            global_info.start_round = 1;
            theprint('###########Starting round#############');
        end;
    end;
end;
if strcmp(transition.name, 'tTableIn'),
    if and(global_info.game_state > 1, ~global_info.cards_dealt_to_table(global_info.game_state))
        theprint('###########Starting new round#########');
        
        global_info.player_bets = [0 0 0 0];
        global_info.start_round = 1;
    end;
end;
if strcmp(transition.name, 'tToDeck')
    cards_in_deck = get_place('pDeck');
    cards_in_deck = cards_in_deck.tokens;
    if cards_in_deck >= 51
        theprint('###########NEW HAND#########');
        global_info.player_bets = [0 0 0 0];
        global_info.end_hand = 0;
    end;
end;
