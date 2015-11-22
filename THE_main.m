clear all; clc;

global global_info;
global_info.print_text = 0;

bluf_preictions1 = [0 0 0 1 0 0 0 0];
bluf_preictions2 = [0 0 0 0 0 0 0 0];

global_info.players = [bluffing_player(0.2,bluf_preictions1),  better_odds_player(), basic_player(), bluffing_player(1,bluf_preictions2), ...
    basic_expect_player(), better_odds_player(), basic_concord_player(), primitive_player()];

player_modules = {'dealer_pdf', 'table_pdf', global_info.players(1).pdf,...
    global_info.players(2).pdf, global_info.players(3).pdf, global_info.players(4).pdf, global_info.players(5).pdf, global_info.players(6).pdf...
    , global_info.players(7).pdf, global_info.players(8).pdf};

global_info.players_index = 0;
global_info.n_players = length(global_info.players);
global_info.blinds = [10 20];
global_info.player_chips = zeros(1, global_info.n_players);
global_info.max_bet = 200;

global_info.MAX_LOOP = 500;

deck = {};

types = {'s','k','h','d'};
values = {'a','2','3','4','5','6','7','8','9','t','j','q','k'};
for i = 1:4
    for j = 1:13
        card = strcat('c',values(j),types(i));
        deck = [deck, card];
    end;
end;

pdfs = {'THE_pdf'};
pdfs = [player_modules pdfs];

pns = pnstruct(pdfs);

results = [global_info.player_chips];

number_of_simulations = 1000;
sums = 0;
sims = 0;

winnings = [];
prevous_winnings = zeros(1,length(global_info.players));

for round = 1:number_of_simulations
    disp(round);
    global_info.bluffs_stoc = rand(1,global_info.n_players);
    global_info.nr_of_turns_in_round = 0;
    global_info.start_round = 0;
    global_info.game_state = 1; % 1: deal cards, 2: flop, 3: turn, 4: river
    global_info.min_raise = global_info.blinds(2);
    global_info.small_blind_player = mod(round, global_info.n_players) +1;
    global_info.getting_to_starting_player = 1;
    global_info.end_hand = 0;
    global_info.end_round = 0;
    
    global_info.player_bets = zeros(1, global_info.n_players);
    
    global_info.cards_dealt_in_state = [global_info.n_players * 2,3,1,1];
    global_info.card_dealt_counter = global_info.n_players * 2;
    global_info.cards_dealt_to_table = [0,3,1,1];
    global_info.pot = 0;
    global_info.has_folded = zeros(1, global_info.n_players);
    global_info.has_called = zeros(1, global_info.n_players);
    global_info.shuffled_deck = deck(randperm(52));
    
    dyn.m0  = {strcat('pTableP',num2str(global_info.small_blind_player),'Out'),1};
    prnsys(pns, dyn);
    pni = initialdynamics(pns, dyn);
    sim = gpensim(pni);
    
    results = [results; global_info.player_chips];
    
    winnings = [winnings; (global_info.player_chips - prevous_winnings)];
    
    prevous_winnings = global_info.player_chips;
    sums = [sums; sum(global_info.player_chips)];
    if sum(global_info.player_chips) ~= 0
        sum(global_info.player_chips)
    end
    
    disp(global_info.player_chips);
    disp(['round ' num2str(round) ' over']);
    
    sims = sims +1;
    plot(0:sims,[results]);
end

plot(0:sims,[results]);

player_legend = [];
for i = 1:length(global_info.players)
    player = global_info.players(i);
    player_legend = [player_legend; {['player ' num2str(i) ': ' player.name]}];
end
legend(player_legend, 'Location','southwest');
xlabel('round');
ylabel('player chips');

