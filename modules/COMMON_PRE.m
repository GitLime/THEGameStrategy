function [fire, transition] = COMMON_PRE(transition)

global global_info;

%theprint(transition.name);

%From dealer to players or table
if strcmp(transition.name, 'tDealer'),
  if and(~global_info.end_hand, isempty(global_info.deck))
      if and(global_info.game_state == 1, global_info.cards_dealt_in_state(1))
         global_info.cards_dealt_in_state(global_info.game_state) = global_info.cards_dealt_in_state(global_info.game_state) -1;
         index = mod(global_info.players_index, length(global_info.players))+1;
         global_info.players_index = global_info.players_index + 1;
         transition.new_color = strcat('pp',num2str(index));
         fire = 1;
         return;
      elseif and(global_info.game_state > 1, global_info.cards_dealt_in_state(global_info.game_state))
         %theprint('Pulling card from deck')
         global_info.cards_dealt_in_state(global_info.game_state) = global_info.cards_dealt_in_state(global_info.game_state) -1;
         fire = 1;
         return;
      end;
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
                %global_info.card_dealt_counter = global_info.cards_dealt_in_state(global_info.game_state);
                if global_info.game_state == 4
                    theprint('#########ENDING HAND#########')
                    global_info.player_bets = [0,0,0,0];
                    global_info.cards_dealt_in_state = [8,3,1,1];
                    global_info.cards_dealt_to_table = [0,3,1,1];
                    global_info.card_dealt_counter = 4;
                    global_info.small_blind_player = mod(global_info.small_blind_player,4)+1;
                    global_info.cards_returned = 0;
                    global_info.end_hand = 1;
                end;
                
                global_info.game_state = mod(global_info.game_state,length(global_info.cards_dealt_in_state))+1;
                theprint(strcat('Game stage: ',num2str(global_info.game_state)));
            else
                % color >= player_chips     --> all-in
                % else
                
                min_bet = global_info.blinds(2);
                call_amount = max(global_info.player_bets);
                play = global_info.player_bets(player_nr);
                
                if call_amount == 0 % can check, or bet
                    if color < min_bet; 
                        play = 0;  %CHECK
                    else; 
                        play = color; end %BET
                else %can fold, call, or raise
                    if color < call; %FOLD
                        global_info.has_folded(player_nr) = 1; 
                    elseif color < call_amount + min_raise; %CALL
                        play = call_amount;
                    else %RAISE
                        play = color;
                        min_raise = play - call_amount;
                    end
                end
                
                
                
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

%From factory to the casi.no
if strcmp(transition.name, 'tMakeCards')
    if isempty(global_info.deck)
        fire = 0;
    else
        transition.new_color = global_info.deck(1);
        global_info.deck = global_info.deck(2:end);
        fire = 1;
    end;
    return;
end

%Player decision
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'Decision')),
        theprint(['Player ', num2str(player_nr), ' decision']);
        
        hand = get_place(strcat('pP', num2str(player_nr), 'Cards'));
        col = hand.token_bank.color;
        col(1)
        
        color = global_info.players(player_nr).decision();
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
        fire = 1;
        return
    end;
    fire = 0;
    return;
end;

%Cards from player or table to deck
if strcmp(transition.name, 'tToDeck'),
    theprint('Sending card back to deck')
    tokID = tokenAny('pDealerCardIn', 1);
    colors = get_color('pDealerCardIn',tokID);
    for i = 1:length(colors)
        temp = colors(i);
        if strcmp(temp(1),'c')
            color = colors(i);
            transition.override = 1;
            transition.new_color = color;
        end;
    end;
    fire = 1;
    return;
end;

%Cards from dealer to table
if strcmp(transition.name, 'tTableIn'),
    if and(global_info.game_state > 1, global_info.cards_dealt_to_table(global_info.game_state) > 0)
        global_info.cards_dealt_to_table(global_info.game_state) = global_info.cards_dealt_to_table(global_info.game_state) -1;
        theprint('Putting card on table');        
        fire = 1;
        return;
    end;
    fire = 0;
    return;
end;

transition.selected_tokens = tokID1;
fire = (tokID1);