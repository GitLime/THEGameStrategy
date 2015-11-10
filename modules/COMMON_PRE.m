function [fire, transition] = COMMON_PRE(transition)

global global_info;

if strcmp(transition.name, 'tDealer_cards'),
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
        tTurn = strcat('pTableP', mod(num2str(player_nr+1),global_info.n_players), 'Out');
        tokTurn = tokenColorless(tTurn, 1);
        if tokTurn ~= 0
            %transition.new_color = {'0','-1','-1','-1'};
            transition.new_color = '0';
        else
            tokTurn = tokenAny(tTurn, 1);
            if tokTurn == 0
                fire = 0;
                return
            end;
            colors = get_color(tTurn, tokTurn);
            %colors = {'0','-1','-1','-1'};
            %colors{1} = '0';
            colors = '0';
            transition.new_color = colors;
            transition.override = 1;
        end;

        fire = 1;
        return;
    end
end

%Decision/turn from player to table
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tTableP', num2str(player_nr), 'In'))
        fire = 1;
        return;
    end
end


%Cards from PDealerOut to players
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'In')),
        tokID1 = tokenAnyColor('pTable',2,{strcat('pp', num2str(player_nr))});
    end
end;

transition.selected_tokens = tokID1;
fire = (tokID1);