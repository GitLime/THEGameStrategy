function strength = hand_strength_with_reads(hand, table, bluf_predictoins)
global global_info;
n_players = length(bluf_predictoins);
if isempty(table)
    ccards = char(hand);
    ccard_values = ccards(:,2);
    card_values = zeros(1,2);
    
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
    twoCardValues = [ ...
        6	4	4	5	4	4	4	5	6	7	7	9	11; ...
        1	7	5	6	5	5	5	5	6	7	8	9	11; ...
        2	3	9	7	6	6	6	6	7	7	8	9	12; ...
        2	3	4	10	7	7	7	7	7	8	9	10	12; ...
        2	3	4	5	12	8	8	8	8	8	9	10	12; ...
        1	2	4	5	6	14	9	9	9	9	10	11	12; ...
        2	2	3	4	6	7	16	10	10	1	11	11	13; ...
        3	3	3	4	6	7	8	18	12	12	12	13	14; ...
        3	4	4	4	6	7	8	10	20	13	14	14	15; ...
        4	4	5	5	6	7	8	10	11	23	14	15	16; ...
        5	5	6	6	7	7	9	10	12	13	25	16	17; ...
        6	7	7	8	8	9	9	11	12	13	14	28	18; ...
        8	9	9	10	9	10	11	12	13	14	15	16	32;];
    
    card_colors = ccards(:,3);
    theprint(['Cards: ', '[',ccards(1,2:3),'] [' ,ccards(2,2:3),']']);
    if card_colors(1) == card_colors(2);
        strength = twoCardValues(min(card_values) - 1, max(card_values) - 1)/40;
        return
    end
    strength = twoCardValues(max(card_values) - 1, min(card_values) - 1)/40;
    return
end

eval = evaluate_hand_consider_teble(hand, table);
p_lose_to_1 = eval.p_gets_beaten;
p_lose = 0;

players_to_call = find(global_info.player_bets == max(global_info.player_bets));

for i = players_to_call
    bluf_predictoin = bluf_predictoins(i);
    i_bluf_predictoins = 1 - bluf_predictoins(i);
    strength_prediction = p_lose_to_1 * i_bluf_predictoins+...
        bluf_predictoin * .5;
    p_lose = p_lose + (1-p_lose)*strength_prediction;
end
p_win = 1 - p_lose;
strength = p_win;

end