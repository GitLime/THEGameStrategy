function [pns] = smpl_player_pdf()

    global global_info;
    
    player_nr = global_info.players_index + 1;
    global_info.players_index = global_info.players_index + 1;
    %we name all Ps and Ts with the player number
    
    
    pns.set_of_Ps = {strcat('pP', num2str(player_nr), 'Cards'), ...
        strcat('pP', num2str(player_nr), 'Turn')};
    %pPlayer1Cards: for holding two cards
    %pPlayer1Turn: for holding the turn token
    
    pns.set_of_Ts = {strcat('tP', num2str(player_nr), 'In'), ...
        strcat('tP', num2str(player_nr), 'Decision')};
    %tPlayer1In: in interface from the table
    %tPlayer1Decision: fires when the player makes a play
    
    pns.set_of_As =  {strcat('pP', num2str(player_nr), 'Turn'),...
        strcat('tP', num2str(player_nr), 'Decision'), 1};