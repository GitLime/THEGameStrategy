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
if strcmp(transition.name, 'tDecision1')
    tokTurn = tokenColorless('pTurn1',1);
    if tokTurn ~= 0
        %transition.new_color = {'0','-1','-1','-1'};
        transition.new_color = '0';
    else
        tokTurn = tokenAny('pTurn1',1);
        if tokTurn == 0
            fire = 0;
            return
        end;
        colors = get_color('pTurn1', tokTurn);
        %colors = {'0','-1','-1','-1'};
        %colors{1} = '0';
        colors = '0';
        transition.new_color = colors;
        transition.override = 1;
    end;
    
    fire = 1;
    return;
elseif strcmp(transition.name, 'tDecision2')
    tokTurn = tokenColorless('pTurn2',1);
    if tokTurn ~= 0
        dist('OMG!')
        transition.new_color = {'-1','0','-1','-1'};
    else
        tokTurn = tokenAny('pTurn2',1)
        if tokTurn == 0
            fire = 0;
            return
        end;
        colors = get_color('pTurn2', tokTurn);

        %colors = {'0','-1','-1','-1'};
        %colors{2} = '0';
        colors = '0';
        transition.new_color = colors;
        transition.override = 1;
    end;
    fire = 1;
    return;
elseif strcmp(transition.name, 'tDecision3')
    tokTurn = tokenColorless('pTurn3',1);
    if tokTurn ~= 0
        transition.new_color = {'-1','-1','0','-1'};
    else
        tokTurn = tokenAny('pTurn3',1);
        if tokTurn == 0
            fire = 0;
            return
        end;
        colors = get_color('pTurn3', tokTurn);
        %colors = {'0','-1','-1','-1'};
        %colors{3} = '0';
        colors = '0';
        transition.new_color = colors;
        transition.override = 1;
    end;
    fire = 1;
    return;
elseif strcmp(transition.name, 'tDecision4')
    tokTurn = tokenColorless('pTurn4',1);
    if tokTurn ~= 0
        transition.new_color = {'-1','-1','-1','0'};
    else
        tokTurn = tokenAny('pTurn4',1);
        if tokTurn == 0
            fire = 0;
            return
        end;        
        colors = get_color('pTurn4', tokTurn);
        %colors = {'0','-1','-1','-1'};
        %colors{4} = '0';
        colors = '0';
        transition.new_color = colors;
        transition.override = 1;
    end;
    fire = 1;
    return;
else
    % not possible
end;

if strcmp(transition.name, 'tP1'),
 tokID1 = tokenAnyColor('pTable',2,{'pp1'});
elseif strcmp(transition.name, 'tP2'),
 tokID1 = tokenAnyColor('pTable',2,{'pp2'});
elseif strcmp(transition.name, 'tP3'),
 tokID1 = tokenAnyColor('pTable',2,{'pp3'});
elseif strcmp(transition.name, 'tP4'),
 tokID1 = tokenAnyColor('pTable',2,{'pp4'});
else
 % not possible to come here
end;

transition.selected_tokens = tokID1;
fire = (tokID1);