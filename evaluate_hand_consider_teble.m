function [ output ] = evaluate_hand_consider_teble( hand, table )
% Returns strength of a hand (output.value) and returns the odds of somone
% having a better hand (output.p_gets_beaten)
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

%TODO kickers

output.p_gets_beaten = 0;

cards = [hand table];

colors = {'s', 'h', 'd', 'k'};

ccards = char(cards);
ccard_values = ccards(:,2);
card_values = zeros(1,length(cards));

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

p_has = zeros(1,9);
cards_left = 52 - length(cards);
hands_left = nchoosek(cards_left, 2);

hands_w_specific_card = (cards_left-1);
p_specific_card = hands_w_specific_card/hands_left;
p_specific_hand = [p_specific_card 1/hands_left 0 0 0];
%... where the index is number of cards requred to satisfy condition


%test for flush
card_colors = ccards(:,3);
table_colors = card_colors(3:end);
table_values = card_values(3:end);
hand_colors = card_colors(1:2);
hand_values = card_values(1:2);


u_table_colors = unique(table_colors);
table_colors_hist = histc(table_colors,u_table_colors);

[max_color, max_color_i] = max(table_colors_hist);
can_have_flush = max_color >= 3;

if can_have_flush
    flush_color = u_table_colors(max_color_i);
    flush_values = card_values(card_colors == flush_color);
    flush_hand_values = hand_values(hand_colors == flush_color);
    flush_table_values = table_values(table_colors == flush_color);
    
    % has_value: one if the table has this value
    has_value = zeros(3,14);
    has_value(1, flush_table_values) = 1;
    has_value(2, flush_hand_values) = 1;
    has_value(3, flush_values) = 1;
    
    % ace is also 1
    has_value(:,1) = has_value(:,14);
    
    for start_card = fliplr(1:10)
        sequence = start_card:start_card+4;
        if ~any(~has_value(3,sequence))
            %has sf
            output.value = 8;
            return;
        end
        if any(has_value(2,sequence))
            %the player has a card on hand that is required for sf
            cards_required_for_sf = 5;
        else
            n_of_same_color_on_table = sum(has_value(1,sequence));
            cards_required_for_sf = 5 - n_of_same_color_on_table;
        end
        output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) ...
            * p_specific_hand(cards_required_for_sf);
    end
    top_flus_card = 0;
    if sum(has_value(3,:)) >= 5
        top_flus_card = max(flush_values);
    end;
end

card_value_hist = histc(card_values,1:14);
hand_value_hist = histc(hand_values,1:14);
table_value_hist = histc(table_values,1:14);

%can have 4oak or house?
if any(table_value_hist >= 2)
    
    %4oak
    foak_value = find(card_value_hist == 4);
    card_required_for_foak = 4 - table_value_hist;
    %remove cards lower than our eventual foak value
    card_required_for_foak(1:foak_value) = 5;
    %remove card on hand
    card_required_for_foak(hand_value_hist > 0) = 5;
    output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
        sum(p_specific_hand(card_required_for_foak));
    
    if foak_value
        output.value = 7;
        return;
    end
    
    %house
    has_house = or(and(any(card_value_hist == 3), any(card_value_hist == 2)),...
        sum(card_value_hist == 3) == 2);
    if has_house
        output.value = 6;
        return;
    end
    
    table_pair_values = find(table_value_hist == 2);
    cards_on_table = length(table);
    
    %pair on table
    others = cards_on_table - length(table_pair_values)*2;
    %w pair on hand
    
    output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
        others * 3 * p_specific_hand(2);
    
    %wo pair on hand
    output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
        length(table_pair_values)* 2 * others * 6 * p_specific_hand(2);
    
    %3oak on table
    if any(table_value_hist == 3);
        others = cards_on_table - 3;
        output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
            others * 3 * p_specific_hand(1);
    end
end

if can_have_flush
    if top_flus_card
        %has_flush
        output.value = 4;
        return;
    end
    cards_required_for_flush = 5 - length(flush_table_values);
    colors_left = 13 - sum(has_value(3,:));
    if cards_required_for_flush == 2
        output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
            nchoosek(colors_left, 2) * p_specific_hand(2);
    elseif cards_required_for_flush == 1
        other_cards = cards_left - 1;
        output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
            colors_left * other_cards * p_specific_hand(2);
    end
end

% has_value: one if the table has this value
has_value = zeros(3,14);
has_value(1, table_values) = 1;
has_value(2, hand_values) = 1;
has_value(3, card_values) = 1;
% ace is also 1
has_value(:,1) = has_value(:,14);
for start_card = fliplr(1:10)
    sequence = start_card:start_card+4;
    if ~any(~has_value(3,sequence))
        %has straight
        output.value = 4;
        return;
    end
    cards_in_sequence_on_table = sum(has_value(1,sequence));
    cards_required_for_sraight = 5 - cards_in_sequence_on_table;
    if cards_required_for_sraight == 1
        
        output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
            p_has(4) + 4 * p_specific_hand(1);
    elseif cards_required_for_sraight == 1
        
        output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
            p_has(4) + 16 * p_specific_hand(1);
    end
end

toak_value = card_value_hist(card_value_hist == 3);
if isempty(toak_value)
    toak_value = 0;
else
    toak_value = max(toak_value);
end

%3oak
toak_value = find(card_value_hist == 3);
card_required_for_toak = 3 - table_value_hist;
%remove cards lower than our eventual toak value
card_required_for_toak(1:toak_value) = 5;
%remove card on hand
card_required_for_toak(hand_value_hist == 2) = 5;
output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
    sum(p_specific_hand(card_required_for_toak));

if toak_value
    %has 3oak
    output.value = 3;
    return;
end


pairs = find(card_value_hist == 2);
if length(pairs) >= 2
    %has 2 pair
    output.value = 2;
    return;
end
pair_on_tabe = table_value_hist(table_value_hist == 2);
if length(pair_on_tabe) == 1
    others = cards_on_table - 2;
    
    output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
        others * p_specific_hand(1);
else
    cards_on_table = length(table);
    
    hads_w_2_pair = cards_on_table * (3*(cards_on_table-1)*3);
    p_2_pair = hads_w_2_pair/hands_left;
    output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
        p_2_pair;
end

%pair
pair_value = max(find(card_value_hist == 2));
if isempty(pair_value)
    pair_value = 1;
end
card_required_for_pair = 2 - table_value_hist;
%remove cards lower than our eventual foak value
card_required_for_pair(1:pair_value) = 5;
cards_left_hist = 4 - card_value_hist;

for card = fliplr(pair_value:14)
    if card_required_for_pair(card) == 2
        output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
            p_specific_hand(2) * nchoosek(cards_left_hist(card),2);
    elseif card_required_for_pair(card) == 1
        output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
            p_specific_hand(1) * cards_left_hist(card);
    end
end

if pair_value > 1
    %has pair
    output.value = 1;
    return;
end

% add probability that some one has a higher card on hand
high_card = max(hand_values);

% cards that will win with beat my high card:
higher_cards = max(14 - length(table) - high_card, 5);

hands_w_only_1 = 4 * (cards_left-4);
p_only_1 = hands_w_only_1 / hands_left;
for i = 1:higher_cards
    output.p_gets_beaten = output.p_gets_beaten + (1 - output.p_gets_beaten) * ...
        p_only_1;
end

output.value = 0;
return;