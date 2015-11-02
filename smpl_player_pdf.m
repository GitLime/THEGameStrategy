function [pns] = smpl_player_pdf()
    player_nr = global_info.player_nr;
    global_info.player_nr = global_info.player_nr + 1;
    %we name all Ps and Ts with the player number
    
    
    pns.set_of_Ps = {strcat('pPlayer', num2str(player_nr), 'Cards'), ...
        strcat('pPlayer', num2str(player_nr), 'Turn')};
    %pPlayer1Cards: for holding two cards
    %pPlayer1Turn: for holding the turn token
    
    pns.set_of_Ts = {strcat('tPlayer', num2str(player_nr), 'In'), ...
        strcat('tPlayer', num2str(player_nr), 'Decision')};
    %tPlayer1In: in interface from the table
    %tPlayer1Decision: fires when the player makes a play
    
    pns.set_of_As =  {strcat('tPlayer', num2str(player_nr), 'Decision'),...
        strcat('tPlayer', num2str(player_nr), 'Decision'), 1};