clear all; clc;

global global_info;

global_info.print_text = 1;
global_info.players = {'p1','p2','p3','p4'};
global_info.players_index = 0;
global_info.n_players = 4;
global_info.card_dealt_counter = 4;

global_info.start_round = 0;

global_info.end_hand = 0;
global_info.player_bets = [0,0,0,0];
global_info.last_rounds_bet = 0;
%Game states = 0: deal cards, 1: flop, 2: turn, 3: river
global_info.game_state = 1;
global_info.cards_dealt_in_state = [8,3,1,1];

player_modules = {'dealer_pdf', 'table_pdf', 'smpl_player_pdf', 'smpl_player_pdf', 'smpl_player_pdf', 'smpl_player_pdf'};
pdfs = {'THE_module_pdf'};
pdfs = [player_modules pdfs];

%TODO: END HAND AND RESET CARDS etc.

pns = pnstruct(pdfs);

dyn.m0  = {'pDeck',13, 'pTableP1Out',1};
%dyn.m0  = {'pTableP1Out',1};

prnsys(pns, dyn);

pni = initialdynamics(pns, dyn);

sim = gpensim(pni); % perform simulation runs

prnss(sim); % print the simulation results