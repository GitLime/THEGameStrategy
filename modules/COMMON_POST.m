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
    