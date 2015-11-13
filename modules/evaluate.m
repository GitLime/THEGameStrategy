function [ winners ] = evaluate( hands, table )
    %foreach hand: make a 7 card set and evaluate it
    hand_types = [];
    hand_cards = [];
    hands = containers.Map;
    for k = hands.keys
        hand = hands(char(k));
        cards = [hand table];
        eval = evaluate_hand(cards);
        hand_types = [hand_types eval.value];
        hands(char(k)) = eval;
    end 
    m = max(hand_types);
    top_hands = find(hand_types == m);
    if length(top_hands) == 1
        winners = top_hands;
        return
    end
    top_hands = [];
    for hand = hands
        top_hands =[top_hands; hand.hand]
    end
    

end

