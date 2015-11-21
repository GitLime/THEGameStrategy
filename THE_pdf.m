function[pns] = THE_pdf()

global global_info;

pns.PN_name = 'Texas Hold Em';

%decisionTransitions = {'tDecision1', 'tDecision2', 'tDecision3', 'tDecision4'}
%roundPlaces = {'pTurn1','pTurn2','pTurn3','pTurn4'}
<<<<<<< HEAD

pns.set_of_Ps = {'pDealer', 'pp1', 'pp2', 'pp3', 'pp4', 'pTable','pTurn1','pTurn2','pTurn3','pTurn4'};
pns.set_of_Ts = {'tDealer_cards', 'tP1', 'tP2','tP3','tP4','tDecision1', 'tDecision2', 'tDecision3', 'tDecision4'};

pns.set_of_As =  {'pDealer', 'tDealer_cards', 1, 'tDealer_cards', 'pTable', 1, 'pTable', 'tP1', 2, ...
    'pTable', 'tP2', 2, 'pTable', 'tP3', 2, 'pTable', 'tP4', 2, 'tP1', 'pp1', 2, 'tP2', 'pp2', 2, ...
    'tP3', 'pp3', 2, 'tP4', 'pp4', 2, 'pTurn1', 'tDecision1', 1, 'tDecision1', 'pTurn2', 1, ...
    'pTurn2', 'tDecision2', 1, 'tDecision2', 'pTurn3', 1, 'pTurn3', 'tDecision3', 1, 'tDecision3', 'pTurn4', 1, ...
    'pTurn4', 'tDecision4', 1, 'tDecision4', 'pTurn1', 1,};
=======
%pns.set_of_Ts = {'tDealer_cards', 'tP1', 'tP2','tP3','tP4'}

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

%disp(pns.set_of_As)
>>>>>>> 77b1d0b88b92c078e3c8f862f8ffdc1271f4790c
