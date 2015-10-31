function[pns] = the_pdf()
pns.PN_name = 'Texas Hold Em';

%decisionTransitions = {'tDecision1', 'tDecision2', 'tDecision3', 'tDecision4'}
%roundPlaces = {'pTurn1','pTurn2','pTurn3','pTurn4'}

pns.set_of_Ps = {'pDealer', 'pp1', 'pp2', 'pp3', 'pp4', 'pTable','pTurn1','pTurn2','pTurn3','pTurn4'};
pns.set_of_Ts = {'tDealer_cards', 'tP1', 'tP2','tP3','tP4','tDecision1', 'tDecision2', 'tDecision3', 'tDecision4'}
%pns.set_of_Ts = {'tDealer_cards', 'tP1', 'tP2','tP3','tP4'}
pns.set_of_As =  {'pDealer', 'tDealer_cards', 1, 'tDealer_cards', 'pTable', 1, 'pTable', 'tP1', 2, ...
    'pTable', 'tP2', 2, 'pTable', 'tP3', 2, 'pTable', 'tP4', 2, 'tP1', 'pp1', 2, 'tP2', 'pp2', 2, ...
    'tP3', 'pp3', 2, 'tP4', 'pp4', 2, 'pTurn1', 'tDecision1', 1, 'tDecision1', 'pTurn2', 1, ...
    'pTurn2', 'tDecision2', 1, 'tDecision2', 'pTurn3', 1, 'pTurn3', 'tDecision3', 1, 'tDecision3', 'pTurn4', 1, ...
    'pTurn4', 'tDecision4', 1, 'tDecision4', 'pTurn1', 1,};