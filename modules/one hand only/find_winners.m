function [ winners ] = find_winners( hands, table )
    %foreach hand: make a 7 card set and evaluate it
    global global_info;
    
    global_info.hands = hands;
    hand_types = [];
    hand_cards = [];
    strenths = [];
    for row = 1:length(hands(:,1));
        hand = hands(row,:);
        cards = [hand table];
        eval = evaluate_hand(cards);
        hand_types = [hand_types eval.value];
        hand_cards = [hand_cards; eval.hand];
    end 
    hand_cards
    winners = find(hand_types == max(hand_types));
    
    if length(winners) == 1
        return; 
    end
    
    winner_hands = hand_cards(winners, :)
    winner_hands = sortrows(winner_hands, fliplr(-5:-1))
    top_hand = winner_hands(1,:);
    
    winners = [];
    for row = 1:length(hand_cards(:,1))
        hand = hand_cards(row,:);
        if hand == top_hand
            winners = [winners row];
        end
    end 
    
    return;
    
    
    
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
    top_hands = sortrows(top_hands, fliplr(-5:-1));
    top_hand = top_hands(1,:);
    
    winners = [];
    for k = winners_eval.keys
        if winners_eval(char(k)).hand == top_hand;
            winners = [winners k];
        end
    end 
end

