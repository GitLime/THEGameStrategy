function [pns] = dealer_pdf()
    pns.set_of_Ps = {'pDealerOut'};
    pns.set_of_Ts = {'tDealer'};
    pns.set_of_As =  {'tDealer', 'pDealerOut', 1};
end
