function [ winners ] = find_winners( hands, table )
    %foreach hand: make a 7 card set and evaluate it
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
    
    %compare 5 card hands and determine winner
    winners = find(hand_types == max(hand_types));
    if length(winners) == 1
        return; 
    end
    
    winner_hands = hand_cards(winners, :);
    winner_hands = sortrows(winner_hands, fliplr(-5:-1));
    top_hand = winner_hands(1,:);
    winners = [];
    for row = 1:length(hand_cards(:,1))
        hand = hand_cards(row,:);
        if hand == top_hand
            winners = [winners row];
        end
    end 
end

