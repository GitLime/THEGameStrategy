clear all; clc;

global global_info;

global_info.players = {'p1','p2','p3','p4'};
global_info.players_index = 0;

pns = pnstruct('THE_pdf');

dyn.m0  = {'pDealer',16};

prnsys(pns, dyn);

pni = initialdynamics(pns, dyn);

sim = gpensim(pni); % perform simulation runs

prnss(sim); % print the simulation results