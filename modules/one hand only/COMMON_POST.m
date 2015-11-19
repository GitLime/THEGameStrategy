function [] = COMMON_POST(transition)

global global_info;

%Checking if round is ready to start
if strcmp(transition.name(1:2), 'tP')
    player_nr = str2double(transition.name(3));
    tName = transition.name(4:end);
    
    if strcmp(tName, 'In')
        theprint(['player ' num2str(player_nr) ' took cards']);
        global_info.card_dealt_counter = global_info.card_dealt_counter - 1;
        if global_info.card_dealt_counter == 0,
            global_info.start_round = 1;
            theprint('###########Starting round#############');
            global_info.has_called = zeros(1, global_info.n_players);
        end;
    end;
end;
if strcmp(transition.name, 'tTableIn'),
    if and(global_info.game_state > 1, ~global_info.cards_dealt_to_table(global_info.game_state))
        theprint('###########Starting new round#########');
        global_info.getting_to_starting_player = 1;
        global_info.player_bets = zeros(1, global_info.n_players);
        global_info.start_round = 1;
        global_info.has_called = zeros(1, global_info.n_players);
    end;
end;
