function [pns] = table_pdf()

    global global_info;
    
    n_players = global_info.n_players;
    
    pns.set_of_Ts = {'tTableIn'};
    pns.set_of_Ps = {'pTable'};
    pns.set_of_As = {'tTableIn','pTable',1};
    
    for i = 1:n_players
        player = i;
        next_player = mod(i, n_players) + 1;
        pns.set_of_Ts = [pns.set_of_Ts strcat('tTableP', num2str(player), 'In')];
        pns.set_of_Ps = [pns.set_of_Ps strcat('pTableP', num2str(next_player), 'Out')];
        As = {strcat('tTableP', num2str(player), 'In'), strcat('pTableP', num2str(next_player), 'Out'), 1};
        pns.set_of_As = [pns.set_of_As As];
    end
    
    