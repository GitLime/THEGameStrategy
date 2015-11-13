hands = containers.Map;
hands('1') = {'ks', 'kk'};
hands('2') = {'ad', 'qd'};
hands('4') = {'2k', '2h'};
hands('6') = {'4k', '4h'};
table = {'qs', '2d', '4h', 'tk', '3d'};

% for hand = hands.values
%     cards = [hand table];
% end 

for k = hands.keys
    hand = hands(char(k));
    cards = [hand table]
end 

% cards = {'9s' 'ts' 'js' '5k' '5s' 'qs' 'ks'};
% cards = {'8s' '2s' 'ts' '9d' '5s' 'ad' 'ad'};
% evaluate_hand(cards)

% evaluate(hands, table)