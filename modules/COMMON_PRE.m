function [fire, transition] = COMMON_PRE(transition)

global global_info;

%theprint(transition.name);

if strcmp(transition.name, 'tDealer'),
  if and(global_info.game_state == 1, global_info.cards_dealt_in_state(1))
     global_info.cards_dealt_in_state(global_info.game_state) = global_info.cards_dealt_in_state(global_info.game_state) -1;
     index = mod(global_info.players_index, length(global_info.players))+1;
     global_info.players_index = global_info.players_index + 1;
     transition.new_color = strcat('p',global_info.players(index));
     fire = 1;
     return;
  elseif and(global_info.game_state > 1, global_info.cards_dealt_in_state(global_info.game_state))
     theprint('Pulling card from deck')
     global_info.cards_dealt_in_state(global_info.game_state) = global_info.cards_dealt_in_state(global_info.game_state) -1;
     fire = 1;
     return;
  end;
  
  fire = 0;
  return;
end;

%Initial state =  {-1,-1,-1,-1}
%State is the current player pot, if all over 0 and equal, round end.
%Player turn Decision to tTabIn
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'TurnIn'))
        if ~global_info.start_round
            fire = 0;
            return;
        end
        pTurn = strcat('pTableP', num2str(player_nr,global_info.n_players), 'Out');
        tokTurn = tokenColorless(pTurn, 1);
        if tokTurn ~= 0
            %transition.new_color = {'0','-1','-1','-1'};
            transition.new_color = '0';
        else
            tokTurn = tokenAny(pTurn, 1);
            if tokTurn == 0
                fire = 0;
                return
            end;
            %theprint(tokTurn);
            colors = get_color(pTurn, tokTurn);   
            %test = get_place('pP1Cards');
            %place = test.token_bank;
            %col = place.color;
            %disp('GUBBE SNAKK')
            %disp(place.color)
            %colors = {'0','-1','-1','-1'};
            %colors{1} = '0';
            %colors = '0';
            %transition.new_color = colors;
            %transition.override = 1;
        end;

        fire = 1;
        return;
    end
end

%Decision/turn from player to table
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tTableP', num2str(player_nr), 'In'))
        if strcmp(global_info.player_bets(player_nr), '-1')
            fire = 1;
            return
        else
            pTurnOut = strcat('pP', num2str(player_nr), 'TurnOut');
            tokID = tokenAny( pTurnOut,1 );
            color = get_color(pTurnOut,tokID);

            if and(strcmp(color, num2str(global_info.player_bets(player_nr))),global_info.nr_of_turns_in_round > length(global_info.players)-1)
                theprint('###########Ending round###########')
                global_info.nr_of_turns_in_round = 0;
                global_info.player_bets(player_nr) = str2double(color);
                global_info.start_round = 0;
                global_info.last_rounds_bet = num2str(global_info.player_bets(player_nr));
                %global_info.player_bets = [0,0,0,0];
                global_info.game_state = mod(global_info.game_state,length(global_info.cards_dealt_in_state))+1;
                disp(strcat('Game stage: ',num2str(global_info.game_state)));
                %global_info.card_dealt_counter = global_info.cards_dealt_in_state(global_info.game_state);
                if global_info.game_state == 1
                    theprint('#########ENDING HAND#########')
                    global_info.end_hand = 1;
                end;
            else
                global_info.player_bets(player_nr) = str2double(color);
                global_info.nr_of_turns_in_round = global_info.nr_of_turns_in_round + 1;
            end
        end
        fire = 1;
        return;
    end
end


%Cards from PDealerOut to players
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'In')),
        tokID1 = tokenAnyColor('pDealerOut',2,{strcat('pp', num2str(player_nr))});
    end
    if strcmp(transition.name, strcat('tTableP', num2str(player_nr), 'In')),
        tokID1 = tokenAny( strcat('tTableP', num2str(player_nr), 'In'),1 );
    end
end;

if strcmp(transition.name, 'tDealer')
    tokID1 = tokenAny('pDeck', 1);
end

%Player decision
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'Decision')),
        theprint(['Player ', num2str(player_nr), ' decision']); 
        color = strategy_smpl(200,player_nr);
        
        transition.override = 1;
        transition.new_color = num2str(color);
        fire = 1;
        return
    end
end

%Cards out from player
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'CardOut')),
        if global_info.end_hand
            %theprint('Sending card from player')
            fire = 1;
            return
        end;
    fire = 0;
    return;
    end;
end;

%tTableCardOut
if strcmp(transition.name, 'tTableCardOut'),
    if global_info.end_hand
        %theprint('Sending card from table')
        fire = 1;
        return
    end;
    fire = 0;
    return;
end;

%Cards from player or table to deck
if strcmp(transition.name, 'tDealerCardIn'),
    theprint('Sending card back to dealer')
    fire = 1;
    return;
end;

%Cards from player to deck
if strcmp(transition.name, 'tTableIn'),
    if and(global_info.game_state > 1, global_info.cards_dealt_in_state(global_info.game_state))
        fire = 1;
        return;
    elseif and(global_info.game_state > 1, ~global_info.start_round)
        theprint('###########Starting new round#########');
        global_info.start_round = 1;
    end;
    fire = 0;
    return;
end;

transition.selected_tokens = tokID1;
fire = (tokID1);