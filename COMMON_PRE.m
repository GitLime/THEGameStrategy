function [fire, transition] = COMMON_PRE(transition)
global global_info;

%From dealer to players or table
if strcmp(transition.name, 'tDealer'),
    fire = 0;
    if ~global_info.end_hand
        %deal cards to players
        if global_info.cards_dealt_in_state(global_info.game_state)
            transition.new_color = global_info.shuffled_deck(1);
            global_info.shuffled_deck = global_info.shuffled_deck(2:end);
            global_info.cards_dealt_in_state(global_info.game_state) = global_info.cards_dealt_in_state(global_info.game_state) -1;
            
            if global_info.game_state == 1
                index = mod(global_info.players_index, length(global_info.players))+1;
                global_info.players_index = global_info.players_index + 1;
                transition.new_color = [transition.new_color strcat('pp',num2str(index))];
            end
            fire = 1;
            return;
        end
    end;
    return;
end;

%Player turn Decision to tTabIn
if strcmp(transition.name(1:2), 'tP')
    player_nr = str2double(transition.name(3));
    tName = transition.name(4:end);
    
    if strcmp(tName, 'TurnIn')
        if ~global_info.start_round
            fire = 0;
            return;
        end
        pTurn = strcat('pTableP', num2str(player_nr,global_info.n_players), 'Out');
        tokTurn = tokenColorless(pTurn, 1);
        if tokTurn ~= 0
            transition.new_color = num2str(global_info.player_bets(player_nr));
        else
            tokTurn = tokenAny(pTurn, 1);
            if tokTurn == 0
                fire = 0;
                return
            end;
        end;
        fire = 1;
        return;
    elseif strcmp(tName, 'In'),
        tokID1 = tokenAnyColor('pDealerOut',1,{strcat('pp', num2str(player_nr))});
        if tokID1
            colors = get_color('pDealerOut', tokID1);
            for i = 1:length(colors)
                temp = char(colors(i));
                if strcmp(temp(1),'c')
                    color = colors(i);
                    transition.override = 1;
                    transition.new_color = color;
                end;
            end
        end;
        fire = (tokID1);
        return;
    elseif strcmp(tName, 'Decision'),
        global_info.players_turn = player_nr;
        theprint(['Player', num2str(player_nr), ' decision']);
        
        if and(and(player_nr == global_info.small_blind_player, global_info.game_state ~= 1), global_info.getting_to_starting_player)
            global_info.getting_to_starting_player = 0;
        end
        
        if global_info.getting_to_starting_player
            if global_info.game_state == 1
                if player_nr == global_info.small_blind_player;
                    transition.new_color = num2str(global_info.blinds(1));
                elseif player_nr == mod(global_info.small_blind_player, global_info.n_players) +1;
                    transition.new_color = num2str(global_info.blinds(2));
                    global_info.getting_to_starting_player = 0;
                end
            else
                transition.new_color = '0';
            end
            fire = 1;
            transition.override = 1;
            return;
        end
        
        if global_info.has_folded(player_nr)
            fire = 1;
            transition.override = 1;
            transition.new_color = '0';
            return
        end;
        
        place = get_place(strcat('pP', num2str(player_nr), 'Cards'));
        banks = place.token_bank;
        hand = [banks(1).color banks(2).color];
        
        table = [];
        place = get_place('pTable');

        banks = place.token_bank;
        for bank = banks
            table = [table bank.color];
        end
        global_info.player_nr = player_nr;
        global_info.call_amount = max(global_info.player_bets) - global_info.player_bets(player_nr);
         color = global_info.players(player_nr).decision(hand,table,global_info.players(player_nr).parameters);

        transition.override = 1;
        transition.new_color = num2str(color);
        fire = 1;
        return
    end
end

%Cards from dealer to table
if strcmp(transition.name, 'tTableIn'),
    if global_info.game_state > 1
        global_info.cards_dealt_to_table(global_info.game_state) = global_info.cards_dealt_to_table(global_info.game_state) -1;
        theprint('Putting card on table');
        fire = 1;
        return;
    end;
    fire = 0;
    return;
end;
        
if strcmp(transition.name(1:min(end,7)), 'tTableP')
    if and(global_info.getting_to_starting_player, global_info.game_state ~= 1)
        theprint('getting to starting player');
        fire = 1;
        return;
    end 
    player_nr = str2double(transition.name(8));
    tName = transition.name(9:end);     
    
    if strcmp(tName, 'In')
        if strcmp(global_info.player_bets(player_nr), '-1')
            fire = 1;
            return
        else
            pTurnOut = strcat('pP', num2str(player_nr), 'TurnOut');
            tokID = tokenAny( pTurnOut,1 );
            color = get_color(pTurnOut,tokID);
            
            play = global_info.player_bets(player_nr);
            
            if global_info.has_folded(player_nr)
                theprint(['    Player' num2str(player_nr) ' has folded']);
                global_info.nr_of_turns_in_round = global_info.nr_of_turns_in_round + 1;
                fire = 1;
                return;
            end
            
            call_amount = max(global_info.player_bets);
            color = str2double(char(color));
            
            if color > global_info.max_bet
                color = global_info.max_bet;
            end
            
            if call_amount == 0 % can check, or bet
                is_smal_blind = and(and( ...
                    player_nr == global_info.small_blind_player,...
                    global_info.game_state == 1),...
                    global_info.getting_to_starting_player);
                min_bet = global_info.blinds(2-is_smal_blind);
                if color < min_bet;
                    play = 0;  %CHECK
                    play_type = 'check';
                else
                    play = color;
                    play_type = 'bet';
                    global_info.min_raise = play;
                end %BET
            else %can fold, call, or raise
                if color < call_amount; %FOLD
                    global_info.has_folded(player_nr) = 1;
                    play_type = 'fold';
                elseif color < call_amount + global_info.min_raise; %CALL
                    play = call_amount;
                    play_type = 'call';
                else %RAISE
                    play = color;
                    global_info.min_raise = play - call_amount;
                    play_type = 'raise';
                end
            end
            play = round(play);
            global_info.player_bets(player_nr) =  max([play global_info.player_bets(player_nr)]);
            theprint(['    Player' num2str(player_nr) ' wants to play ' num2str(color)]);
            theprint(['    Player' num2str(player_nr) ' played ' num2str(play) ' (' play_type ')']);
            global_info.nr_of_turns_in_round = global_info.nr_of_turns_in_round + 1;
            
            if or(strcmp(play_type, 'bet'), strcmp(play_type, 'raise'))
                global_info.has_called = zeros(1, global_info.n_players);
                global_info.has_called(player_nr) = 1;
            elseif and(or(strcmp(play_type, 'check'), strcmp(play_type, 'call')), ~global_info.getting_to_starting_player);
                global_info.has_called(player_nr) = 1;
            end
            
            %check if round is over
            if sum(or(global_info.has_called, global_info.has_folded)) == global_info.n_players;
                theprint('###########Ending round###########')
                global_info.pot = global_info.pot + sum(global_info.player_bets);
                theprint(['bets size: ' num2str(global_info.player_bets)]);
                theprint(['pot size: ' num2str(global_info.pot)]);
                global_info.player_chips = global_info.player_chips - global_info.player_bets;
                global_info.player_bets = [0,0,0,0];
                global_info.min_raise = 0;
                global_info.nr_of_turns_in_round = 0;
                %global_info.player_bets(player_nr) = str2double(color);
                global_info.start_round = 0;
                %global_info.card_dealt_counter = global_info.cards_dealt_in_state(global_info.game_state);
                if or(global_info.game_state == 4, sum(global_info.has_folded) == global_info.n_players - 1)
                %if or(global_info.game_state == 4, 0)
                    theprint('#########ENDING HAND#########')
                    global_info.end_hand = 1;
                    end_hand();
                    theprint(['cihps: ' num2str(global_info.player_chips)]);
                    global_info.game_state = 1;
                else
                    global_info.game_state = mod(global_info.game_state,length(global_info.cards_dealt_in_state))+1;
                end;
                theprint(strcat('Game stage: ',num2str(global_info.game_state)));
                
            end
            fire = 1;
            return;
        end
    end
end

fire = 1;
