clear all; clc;

global global_info;

global_info.print_text = 1;
global_info.players = [basic_player(), basic_player(), basic_player(), basic_player()];
global_info.players_index = 0;
global_info.n_players = length(global_info.players);
global_info.blinds = [10 20];

%Between rounds
global_info.start_round = 0;
global_info.game_state = 1; % 1: deal cards, 2: flop, 3: turn, 4: river
global_info.last_rounds_bet = 0;
global_info.nr_of_turns_in_round = 0;
global_info.min_raise = 0;
%global_info.has_folded = zeros(1, global_info.n_players);
%Between hands
global_info.end_hand = 0;
global_info.small_blind_player = 1;
global_info.player_bets = zeros(1, global_info.n_players);
global_info.cards_dealt_in_state = [8,3,1,1];
global_info.card_dealt_counter = global_info.n_players;
global_info.cards_dealt_to_table = [0,3,1,1];
global_info.cards_returned = 0;

global_info.MAX_LOOP = 500;
player_modules = {'dealer_pdf', 'table_pdf', global_info.players(1).pdf,...
    global_info.players(2).pdf, global_info.players(3).pdf, global_info.players(4).pdf,};
pdfs = {'THE_module_pdf'};
pdfs = [player_modules pdfs];

%TODO: END HAND AND RESET CARDS etc.

pns = pnstruct(pdfs);

dyn.m0  = {'pDeck',52, strcat('pTableP',num2str(global_info.small_blind_player),'Out'),1};
%strcat('pTableP',num2str(small_blind_player),'Out')
%dyn.m0  = {'pTableP1Out',1};

prnsys(pns, dyn);

pni = initialdynamics(pns, dyn);

sim = gpensim(pni); % perform simulation runs

prnss(sim); % print the simulation results
plotp(sim, {'pDeck'});
