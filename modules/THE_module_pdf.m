function[pns] = THE_module_pdf()

global global_info;

pns.PN_name = 'Texas Hold Em';

%decisionTransitions = {'tDecision1', 'tDecision2', 'tDecision3', 'tDecision4'}
%roundPlaces = {'pTurn1','pTurn2','pTurn3','pTurn4'}
%pns.set_of_Ts = {'tDealer_cards', 'tP1', 'tP2','tP3','tP4'}

pns.set_of_As = {};

n_players = global_info.n_players;
for i = 1:n_players
    player = i;
    next_player = mod(i, n_players) + 1;
    strcat('pP', num2str(player), 'Cards');
    strcat('tP', num2str(player), 'Decision');
    As = {'pTable', strcat('tP', num2str(player), 'In'),2,... %table to player
         strcat('tP', num2str(player), 'Decision'),...
         strcat('pP', num2str(next_player), 'Turn'), 1,}; %player to next player
    pns.set_of_As = [pns.set_of_As As];
end
   
pns.set_of_Ps = {'pDealer', 'pTable',};
pns.set_of_Ts = {'tDealer_cards'};
As =  {'pDealer', 'tDealer_cards', 1, 'tDealer_cards', 'pTable', 1};
pns.set_of_As = [pns.set_of_As As];
%disp(pns.set_of_As)