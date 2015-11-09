function [] = COMMON_POST(transition)

    global global_info;

    if strcmp(transition.name, 'tP1'),
        global_info.card_dealt_counter = global_info.card_dealt_counter - 1;
            if global_info.card_dealt_counter == 0,
            global_info.start_round = 1;
            end;
    elseif strcmp(transition.name, 'tP2'),
        global_info.card_dealt_counter = global_info.card_dealt_counter - 1;
            if global_info.card_dealt_counter == 0,
            global_info.start_round = 1;
            end;
    elseif strcmp(transition.name, 'tP3'),
        global_info.card_dealt_counter = global_info.card_dealt_counter - 1;
            if global_info.card_dealt_counter == 0,
            global_info.start_round = 1;
            end;
    elseif strcmp(transition.name, 'tP4'),
        global_info.card_dealt_counter = global_info.card_dealt_counter - 1;
            if global_info.card_dealt_counter == 0,
            global_info.start_round = 1;
            end;
    else
        % not possible to come here
    end;
    