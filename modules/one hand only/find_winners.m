function [ winners ] = find_winners( hands, table )
    %foreach hand: make a 7 card set and evaluate it
    hand_types = [];
    hand_cards = [];
    strenths = containers.Map;
    for k = hands.keys
        hand = hands(char(k));
        cards = [hand table];
        eval = evaluate_hand(cards);
        strenths(char(k)) = eval;
        hand_types = [hand_types eval.value];
        hand_cards = [hand_cards; eval.hand];
    end 
    
    m = max(hand_types);
    winners_eval = containers.Map;
    for k = strenths.keys
        if strenths(char(k)).value == m;
            winners_eval(char(k)) = strenths(char(k));
        end
    end 
    
    if length(winners_eval.keys) == 1
        winners = winners_eval.keys;
        return
    end
    
    f = find(hand_types == m);
    top_hands = hand_cards(f,:);
    top_hands = sortrows(top_hands, -1:-5);
    top_hand = top_hands(1,:);
    
    winners = [];
    for k = winners_eval.keys
        if winners_eval(char(k)).hand == top_hand;
            winners = [winners k];
        end
    end 
end
