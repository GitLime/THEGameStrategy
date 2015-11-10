clear all; clc;

global global_info;

global_info.players = {'p1','p2','p3','p4'};
global_info.players_index = 0;
global_info.n_players = 4;

global_info.end_hand = 0;
%global_info.player_decision_states = {''}

player_modules = {'smpl_player_pdf', 'smpl_player_pdf', 'smpl_player_pdf', 'smpl_player_pdf'};
pdfs = {'THE_module_pdf'};
pdfs = [player_modules pdfs];

pns = pnstruct(pdfs);

dyn.m0  = {'pDealer',8, 'pTurn1',1};

prnsys(pns, dyn);

pni = initialdynamics(pns, dyn);

sim = gpensim(pni); % perform simulation runs

prnss(sim); % print the simulation results