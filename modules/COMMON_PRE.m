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
 elseif and(global_info.game_state == 2,global_info.cards_dealt_in_state(2))
     disp('Dealing card to flop')
     global_info.cards_dealt_in_state(global_info.game_state) = global_info.cards_dealt_in_state(global_info.game_state) -1;
     fire = 1;
     return;
 elseif and(global_info.game_state == 3,global_info.cards_dealt_in_state(3))
     disp('Dealing turn card')
     global_info.cards_dealt_in_state(global_info.game_state) = global_info.cards_dealt_in_state(global_info.game_state) -1;
     fire = 1;
     return;
 elseif and(global_info.game_state == 4,global_info.cards_dealt_in_state(4))
     disp('Dealing river card')
     global_info.cards_dealt_in_state(global_info.game_state) = global_info.cards_dealt_in_state(global_info.game_state) -1;
     if global_info.cards_dealt_in_state(global_info.game_state) == 0
        global_info.start_round = 1;
     end;
     fire = 1;
     return;
 end;
 global_info.start_round = 1;
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

            if and(strcmp(color, num2str(global_info.player_bets(player_nr))),(global_info.player_bets(player_nr) > global_info.last_rounds_bet))
                global_info.player_bets(player_nr) = str2double(color);
                global_info.start_round = 0;
                global_info.last_rounds_bet = num2str(global_info.player_bets(player_nr));
                %global_info.player_bets = [0,0,0,0];
                global_info.game_state = mod(global_info.game_state,length(global_info.cards_dealt_in_state))+1;
                disp(strcat('Game stage: ',num2str(global_info.game_state)));
                global_info.card_dealt_counter = global_info.cards_dealt_in_state(global_info.game_state);
            else
                global_info.player_bets(player_nr) = str2double(color);
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
        color = strategy_smpl(200,player_nr);
        
        transition.override = 1;
        transition.new_color = num2str(color);
        fire = 1;
        return
    end
end

transition.selected_tokens = tokID1;
fire = (tokID1);