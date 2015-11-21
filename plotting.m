global global_info;

plot(0:sims-1,[results]);
%title('One basic player up against three primitive players')
player_legend = [];
for i = 1:length(global_info.players)
    player = global_info.players(i);
    player_legend = [player_legend; {['player ' num2str(i) ': ' player.name]}];
end
legend(player_legend, 'Location','southwest');
xlabel('round');
ylabel('player chips');