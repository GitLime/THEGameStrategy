function [pns] = dealer_pdf()
    pns.set_of_Ps = {'pDeck', 'pDealerOut'};
    pns.set_of_Ts = {'tDealer', 'tDealerCardIn'};
    pns.set_of_As =  {'tDealer', 'pDealerOut', 1, 'pDeck', 'tDealer', 1, 'tDealerCardIn', 'pDeck', 1};
end
