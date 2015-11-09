clear all; clc;

global global_info;

global_info.players = {'p1','p2','p3','p4'};
global_info.players_index = 0;

global_info.end_hand = 0;
%global_info.player_decision_states = {''}

pns = pnstruct('THE_pdf');

dyn.m0  = {'pDealer',8, 'pTurn1',1};

prnsys(pns, dyn);

pni = initialdynamics(pns, dyn);

sim = gpensim(pni); % perform simulation runs

prnss(sim); % print the simulation results