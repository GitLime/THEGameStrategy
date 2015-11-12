function [ output ] = evaluate_hand( cards )
% Returns strength of a hand (output.value)
% values for output
    %Straight flush 8
    %Four           7
    %House          6
    %Flush          5
    %Straight       4
    %Three          3
    %two pair       2
    %pair           1
    %high card      0
% Output.hand is the cards used in the optimal han. This variable can be
% used for tie beakers
    
    colors = {'s', 'h', 'd', 'k'};
    
    ccards = char(cards);
    ccard_values = ccards(:,1);
    card_values = zeros(1,7);

    for i = 1:length(ccard_values)
        cval = ccard_values(i);
        if cval == 'a'
            card_values(i) = 14;
        elseif cval == 'k'
            card_values(i) = 13;
        elseif cval == 'q'
            card_values(i) = 12;
        elseif cval == 'j'
            card_values(i) = 11;
        elseif cval == 't'
            card_values(i) = 10;
        else
            card_values(i) = str2double(ccard_values(i));
        end
    end
    
    %test for flush
    card_colors = ccards(:,2);
    has_flush = 0;
    for color = colors
        color = char(color);
        cards_of_color = card_colors == color;
        if sum(cards_of_color) >= 5
            has_flush = 1;
            suited_cards = sort(card_values(cards_of_color),'descend');
            %break;
        end
    end
    
    if has_flush
       %test for straight flush (are suitet_cards 5 in a row)
       prev_card = suited_cards(1);
       in_a_row = [prev_card];
       for card_value = suited_cards(2:end)
            if card_value == prev_card-1 || (prev_card == 2 && card_value == 14)
               in_a_row = [in_a_row card_value];
            else
               in_a_row = [];
            end 
            if length(in_a_row) == 5
                output.value = 8;
                output.hand = in_a_row;
                return;
            end
            prev_card = card_value;
       end           
    end
    
    %
    card_values = sort(card_values, 'descend');
    ucards = unique(card_values);
    value_frquency = [ucards;histc(card_values,ucards)];
    [~,I]=sort(value_frquency(1,:), 'descend');
    value_frquency=value_frquency(:,I);
    ucards = sort(ucards, 'descend');
    
    %4 of a kind
    foak_i = find(value_frquency(2,:) == 4);
    if foak_i 
        foak_value = value_frquency(1, foak_i);
        output.value = 7;
        is_other = value_frquency < 4;
        other_values = value_frquency(1,is_other(2,:));
        output.hand = [foak_value max(other_values)];
        return;
    end 
    
    %House
    toak_i = find(value_frquency(2,:) == 3);
    if toak_i
        toak_i = toak_i(1);
        toak_value = value_frquency(1, toak_i);
        is_other = value_frquency(1,:) ~= toak_value;
        other_values = value_frquency(:,is_other);
        pair_i = find(other_values(2,:) >= 2);
        if pair_i
            pair_i = pair_i(1);
            %has house
            output.value = 6;
            output.hand = [toak_value other_values(1, pair_i)];
            return;
        end
    end
    
    %flush
    if has_flush
        output.value = 5;
        output.hand = suited_cards(1:5);
        return;
    end
    
   %test for straight
   prev_card = ucards(1);
   in_a_row = [prev_card];
   for card_value = ucards(2:end)
       if card_value == prev_card-1 || (prev_card == 2 && card_value == 14)
           in_a_row = [in_a_row card_value];
       else
           in_a_row = [];
       end
       if length(in_a_row) == 5
           output.value = 4;
           output.hand = in_a_row;
           return;
       end
       prev_card = card_value;
   end
   
   %3 of a kind
   if toak_i
        toak_value = value_frquency(1, toak_i);
        is_other = value_frquency(1,:) ~= toak_value;
        other_values = value_frquency(:,is_other);
        output.value = 3;
        output.hand = [toak_value other_values(1,1:2)];
        return;
   end
   
   %2 pair
   pair_i = find(value_frquency(2,:) == 2);
   if length(pair_i) >= 2
        pair_value = value_frquency(1, pair_i);
        other_values = value_frquency(1,:);
        other_values = other_values(other_values ~= pair_value(1));
        other_values = other_values(other_values ~= pair_value(2));
        output.value = 2;
        output.hand = [pair_value(1) pair_value(2) other_values(1)];
        return;
   end
   
   %pair
   if pair_i
       pair_i = pair_i(1);
       pair_value = value_frquency(1, pair_i);
       other_values = value_frquency(1,:);
       other_values = other_values(other_values ~= pair_value(1));
       output.value = 1;
       output.hand = [pair_value other_values(1,1:3)];
       return;
   end
   
   %high card
   output.value = 0;
   output.hand = card_values(1:5);
end

