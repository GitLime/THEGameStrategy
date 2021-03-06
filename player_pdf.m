function [pns] = player_pdf()

    global global_info;
    
    player_nr = global_info.players_index + 1;
    global_info.players_index = global_info.players_index + 1;
    %we name all Ps and Ts with the player number
    
    
    pns.set_of_Ps = {strcat('pP', num2str(player_nr), 'Cards'), ...
        strcat('pP', num2str(player_nr), 'TurnOut'), ...
        strcat('pP', num2str(player_nr), 'Decision')};
    %pPlayer1Cards: for holding two cards
    %pPlayer1Turn: for holding the turn token
    
    pns.set_of_Ts = {strcat('tP', num2str(player_nr), 'In'), ...
        strcat('tP', num2str(player_nr), 'TurnIn'), ...
        strcat('tP', num2str(player_nr), 'Decision')};
    %tPlayer1In: in interface from the table
    %tPlayer1Decision: fires when the player makes a play
    
    pns.set_of_As =  {...
        strcat('tP', num2str(player_nr), 'In'), strcat('pP', num2str(player_nr), 'Cards'), 1,...
        strcat('tP', num2str(player_nr), 'TurnIn'), strcat('pP', num2str(player_nr), 'Decision'), 1,...
        strcat('pP', num2str(player_nr), 'Decision'), strcat('tP', num2str(player_nr), 'Decision'), 1,...
        strcat('tP', num2str(player_nr), 'Decision'), strcat('pP', num2str(player_nr), 'TurnOut'), 1};
    