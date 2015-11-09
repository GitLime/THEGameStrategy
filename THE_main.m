clear all; clc;

global global_info;

global_info.players = {'p1','p2','p3','p4'};
global_info.players_index = 0;

% Decisions : 0: Fold, 1: Check, 2: Call, 3: Bet
%global_info.player_decision_states = {''}

% Turn phase: 0: First, 1: Flop, 2: Turn, 3: River
%global_info.turn_number = {0}

% Player roles: 0: Dealer, 1: Small Blind, 2: Big Blind, 3: Starting player
%global_info.player_roles = {0,1,2,3}

% Card dealt counter
global_info.card_dealt_counter = 4;
% Hand ready to start
global_info.start_round = 0;

global_info.end_hand = 0;

pns = pnstruct('THE_pdf');

dyn.m0  = {'pDealer',8, 'pTurn1',1};

prnsys(pns, dyn);

pni = initialdynamics(pns, dyn);

sim = gpensim(pni); % perform simulation runs

prnss(sim); % print the simulation results