function[pns] = THE_pdf()

global global_info;

pns.PN_name = 'Texas Hold Em';

pns.set_of_As = {'pDealerOut', 'tTableIn', 1};
pns.set_of_Ps = {};
pns.set_of_Ts = {};
n_players = global_info.n_players;
for i = 1:n_players
    player = i;
    
    As = {'pDealerOut', strcat('tP', num2str(player), 'In'),1,... %dealer to player
         strcat('pTableP', num2str(player), 'Out'),...
         strcat('tP', num2str(player), 'TurnIn'), 1,... %table to player
         strcat('pP', num2str(player), 'TurnOut'),...
         strcat('tTableP', num2str(player), 'In'), 1}; %player to table
    pns.set_of_As = [pns.set_of_As As];
end
