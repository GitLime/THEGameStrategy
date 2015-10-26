function[pns] = the_pdf()
pns.PN_name = 'Texas Hold Em';
pns.set_of_Ps = {'pDealer', 'pp1', 'pp2', 'pp3', 'pp4', 'pTable'};
pns.set_of_Ts = {'tDealer_cards', 'tP1', 'tP2','tP3','tP4'};
pns.set_of_As =  {'pDealer', 'tDealer_cards', 1, 'tDealer_cards', 'pTable', 1, 'pTable', 'tP1', 2, ...
    'pTable', 'tP2', 2, 'pTable', 'tP3', 2, 'pTable', 'tP4', 2, 'tP1', 'pp1', 2, 'tP2', 'pp2', 2, ...
    'tP3', 'pp3', 2, 'tP4', 'pp4', 2};