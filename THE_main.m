clear all; clc;

global global_info;
global_info.print_text = 0;

% bluf_preictions = [0 0 1 0];
%
% bluf_preictions1 = [0 .5 .2 1];
% bluf_preictions2 = [1 1 1 1];
% bluf_preictions3 = [0 0 0 0];
% bluf_preictions4 = [1 .2 .5 1];
%
% global_info.players = [basic_concord_player2(0,bluf_preictions),...
%     basic_concord_player2(0,bluf_preictions),basic_concord_player2(1,bluf_preictions),basic_concord_player2(0,bluf_preictions)];
%
% global_info.players = [better_odds_player2(0,bluf_preictions1),...
%     better_odds_player2(.5,bluf_preictions2),better_odds_player2(.2,bluf_preictions3),better_odds_player2(1,bluf_preictions4)];
%global_info.players = [basic_expect_player(),better_odds_player(),basic_expect_player(),basic_expect_player()];

global_info.players = [basic_concord_player(), basic_player(), basic_player(), basic_player()];
global_info.players_index = 0;
global_info.n_players = length(global_info.players);
global_info.blinds = [10 20];
global_info.player_chips = zeros(1, global_info.n_players);
global_info.max_bet = 200;

global_info.MAX_LOOP = 200;

deck = {};

%global_info.cards_set_counter = 1;

types = {'s','k','h','d'};
values = {'a','2','3','4','5','6','7','8','9','t','j','q','k'};
for i = 1:4
    for j = 1:13
        card = strcat('c',values(j),types(i));
        deck = [deck, card];
    end;
end;
player_modules = {'dealer_pdf', 'table_pdf', global_info.players(1).pdf,...
    global_info.players(2).pdf, global_info.players(3).pdf, global_info.players(4).pdf};

pdfs = {'THE_pdf'};
pdfs = [player_modules pdfs];

pns = pnstruct(pdfs);

results = [global_info.player_chips];

number_of_simulations = 500;
sums = 0;
sims = 0;

winnings = [];
prevous_winnings = zeros(1,length(global_info.players));

for round = 1:number_of_simulations
    disp(round);
    global_info.blufs_stoc = rand(1,global_info.n_players);
    global_info.nr_of_turns_in_round = 0;
    global_info.start_round = 0;
    global_info.game_state = 1; % 1: deal cards, 2: flop, 3: turn, 4: river
    global_info.min_raise = global_info.blinds(2);
    global_info.small_blind_player = mod(round, global_info.n_players) +1;
    global_info.getting_to_starting_player = 1;
    global_info.end_hand = 0;
    global_info.end_round = 0;
    
    global_info.player_bets = zeros(1, global_info.n_players);
    %     global_info.player_bets(global_info.small_blind_player) = blids(1);
    %     big_blid_player = mod(global_info.small_blind_player, global_info.n_players) +1;
    %     global_info.player_bets(big_blid_player) = blids(2);
    %     starting_player = mod(big_blid_player, global_info.n_players) +1;
    %global_info.max_chips_to_play = 500;
    
    
    global_info.cards_dealt_in_state = [global_info.n_players * 2,3,1,1];
    global_info.card_dealt_counter = global_info.n_players * 2;
    global_info.cards_dealt_to_table = [0,3,1,1];
    global_info.pot = 0;
    global_info.has_folded = zeros(1, global_info.n_players);
    global_info.has_called = zeros(1, global_info.n_players);
    global_info.shuffled_deck = deck(randperm(52));
    
    %     global_info.shuffled_deck = {'cas' 'c5k' 'cad' 'cah' 'ckk' 'ckd' 'ckh' 'cks' ...
    %         'c2s' 'c3h' 'c4d' 'c7k' 'c7s'};
    %    global_info.shuffled_deck = {'cjs'    'c5k'    'c6h'    'cas'    'cth'    'c8h'    'ctk'    'c8k'    'c5d'    'c7d'    'c7s'    'c9d'    'c3h'};
    dyn.m0  = {strcat('pTableP',num2str(global_info.small_blind_player),'Out'),1};
    prnsys(pns, dyn);
    pni = initialdynamics(pns, dyn);
    sim = gpensim(pni); % perform simulation runs
    %prnss(sim); % print the simulation results
    %plotp(sim, {'pDeck'});
    results = [results; global_info.player_chips];
    
    winnings = [winnings; (global_info.player_chips - prevous_winnings)];
    
    prevous_winnings = global_info.player_chips;
    sums = [sums; sum(global_info.player_chips)];
    if sum(global_info.player_chips) ~= 0
        sum(global_info.player_chips)
        %break;
    end
    disp(global_info.player_chips);
    disp(['round ' num2str(round) ' over']);
    
    
    sims = sims +1;
    plot(0:sims,[results]);
end

plot(0:sims,[results]);
%title('One basic player up against three primitive players')
player_legend = [];
for i = 1:length(global_info.players)
    player = global_info.players(i);
    player_legend = [player_legend; {['player ' num2str(i) ': ' player.name]}];
end
legend(player_legend, 'Location','southwest');
xlabel('round');
ylabel('player chips');

