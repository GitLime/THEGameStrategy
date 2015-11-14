function[pns] = THE_module_pdf()

global global_info;

pns.PN_name = 'Texas Hold Em';

%decisionTransitions = {'tDecision1', 'tDecision2', 'tDecision3', 'tDecision4'}
%roundPlaces = {'pTurn1','pTurn2','pTurn3','pTurn4'}
%pns.set_of_Ts = {'tDealer_cards', 'tP1', 'tP2','tP3','tP4'}

pns.set_of_As = {};
pns.set_of_Ps = {};
pns.set_of_Ts = {};

n_players = global_info.n_players;
for i = 1:n_players
    player = i;
    
    As = {'pDealerOut', strcat('tP', num2str(player), 'In'),2,... %dealer to player
         strcat('pTableP', num2str(player), 'Out'),...
         strcat('tP', num2str(player), 'TurnIn'), 1,... %table to player
         strcat('pP', num2str(player), 'TurnOut'),...
         strcat('tTableP', num2str(player), 'In'), 1,... %player to table 
         strcat('pP', num2str(player),'CardOut'), 'tDealerCardIn', 1,... %player to Dealer/ Deck
         'pDealerOut','tTableIn', 1, 'pTableCardOut', 'tDealerCardIn', 1};...%dealer to table
    pns.set_of_As = [pns.set_of_As As];
end

%disp(pns.set_of_As)