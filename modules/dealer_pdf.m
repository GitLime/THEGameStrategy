function [pns] = dealer_pdf()
    pns.set_of_Ps = {'pDeck', 'pDealerOut','pDealerCardIn'};
    pns.set_of_Ts = {'tDealer', 'tToDeck'};
    pns.set_of_As =  {'tDealer', 'pDealerOut', 1, 'pDeck', 'tDealer', 1, 'pDealerCardIn', 'tToDeck', 1, 'tToDeck','pDeck',1};
end
