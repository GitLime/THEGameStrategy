b = winnings(:,1)
b(b>=0) = 1
b(b<0) = 0
[h p] = runstest(b)