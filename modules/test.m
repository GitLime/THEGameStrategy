x =[2 2 7 2 2 1 4];
a = unique(x);
value_frequency = [a;histc(x,a)]
any(value_frequency(2,:) == 4);
other = value_frequency < 4
vals = value_frequency(1,other(2,:))