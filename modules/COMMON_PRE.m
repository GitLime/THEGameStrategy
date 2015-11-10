function [fire, transition] = COMMON_PRE(transition)

global global_info;

%theprint(transition.name);

if strcmp(transition.name, 'tDealer'),
 index = mod(global_info.players_index, length(global_info.players))+1;
 global_info.players_index = global_info.players_index + 1;

 transition.new_color = strcat('p',global_info.players(index));
 fire = 1;
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
    disp(global_info.player_bets)
    disp(global_info.end_hand)
    if strcmp(transition.name, strcat('tTableP', num2str(player_nr), 'In'))
        if strcmp(global_info.player_bets(player_nr), '-1')
            fire = 1;
            return
        else
            pTurnOut = strcat('pP', num2str(player_nr), 'TurnOut');
            tokID = tokenAny( pTurnOut,1 );
            color = get_color(pTurnOut,tokID);
            if strcmp(color, global_info.player_bets(player_nr))
                global_info.player_bets(player_nr) = color;
                global_info.end_hand = 1;
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
        color = strategy_smpl('100',player_nr);
        transition.new_color = color;
        fire = 1;
        return
    end
end

transition.selected_tokens = tokID1;
fire = (tokID1);