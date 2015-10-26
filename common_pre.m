function [fire, transition] = common_pre(transition)

global global_info;

if strcmp(transition.name, 'tDealer_cards'),
 %index = mod(global_info.cr_index, 4)+1;
 %global_info.cr_index = global_info.cr_index + 1;
 %transition.new_color = global_info.cr(index);
 transition.new_color = 'pp1';
 fire = 1;
 return;
end;

if strcmp(transition.name, 'tP1'),
 tokID1 = tokenAnyColor('pTable',1,{'pp1'});
elseif strcmp(transition.name, 'tB'),
 tokID1 = tokenEXColor('pTable',1,{'B'});
elseif strcmp(transition.name, 'tC'),
 tokID1 = tokenAllColor('pTable',1,{'C'});
else
 % not possible to come here
end;

transition.selected_tokens = tokID1;
fire = (tokID1);