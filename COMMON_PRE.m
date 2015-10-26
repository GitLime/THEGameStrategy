function [fire, transition] = COMMON_PRE(transition)

global global_info;

if strcmp(transition.name, 'tDealer_cards'),
 index = mod(global_info.players_index, length(global_info.players))+1;
 global_info.players_index = global_info.players_index + 1;

 transition.new_color = strcat('p',global_info.players(index));
 fire = 1;
 return;
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