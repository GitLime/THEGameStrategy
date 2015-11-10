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
for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'Decision'))
        tTurn = strcat('pP', num2str(player_nr), 'Turn');
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


for player_nr = 1:global_info.n_players
    if strcmp(transition.name, strcat('tP', num2str(player_nr), 'TurnIn')),
        tokID1 = tokenAnyColor('pTable',2,{strcat('pp', num2str(player_nr))});
    end
    if strcmp(transition.name, strcat('tTableP', num2str(player_nr), 'In')),
        tokID1 = tokenAny( strcat('tTableP', num2str(player_nr), 'In'),1 );
    end
end;

transition.selected_tokens = tokID1;
fire = (tokID1);