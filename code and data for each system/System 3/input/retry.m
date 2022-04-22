%得到8_gen系统进行trans之前的数据
data = loadcase('case118');
[n, ~] = size(data.gen);
trans = eye(n);
aim = [30, 40, 37, 28, 29, 5, 12, 11];
repalce = linspace(47, 54, 8);
for i = linspace(1, 8, 8)
    trans(aim(i), aim(i)) = 0;
    trans(aim(i), repalce(i)) = 1;
    trans(repalce(i), repalce(i)) = 0;
    trans(repalce(i), aim(i)) = 1;
end
load('8_gen_other parameters.mat');
ramp_down = trans * ramp_down;
ramp_up = ramp_down;
UCA = (trans * UCA')';
save('8_gen_other parameters.mat', 'demand', 'ramp_up', 'ramp_down', 'UCA')