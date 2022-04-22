load('C:\Users\22390\Desktop\accpm\unified parameter2\740_p_0.98.mat')
data740 = social_cost;
x740 = MSR_list;
load('C:\Users\22390\Desktop\accpm\unified parameter2\770_p_0.98.mat')
data770 = social_cost;
x770 = MSR_list;
load('C:\Users\22390\Desktop\accpm\unified parameter2\800_p_0.98.mat')
data800 = social_cost;
x800 = MSR_list;

load('C:\Users\22390\Desktop\accpm\unified parameter2\simulation740_p_0.98.mat')
sdata740 = social_cost;
sx740 = MSR_list;
load('C:\Users\22390\Desktop\accpm\unified parameter2\simulation770_p_0.98.mat')
sdata770 = social_cost;
sx770 = MSR_list;
load('C:\Users\22390\Desktop\accpm\unified parameter2\simulation800_p_0.98.mat')
sdata800 = social_cost;
sx800 = MSR_list;

% x = linspace(0, 200, 21);
plot(x740, data740, '-+','LineWidth',2, 'MarkerSize', 4, 'color', [0.82, 0.41, 0.12])
hold on;
plot(sx740, sdata740, '-.ro','LineWidth',2, 'MarkerSize', 4, 'color', [0.82, 0.41, 0.12])
hold on;
plot(x770, data770, '-+b','LineWidth',2, 'MarkerSize', 4, 'color', [0.13, 0.55, 0.13])
hold on;
plot(sx770, sdata770, '-.bo','LineWidth',2, 'MarkerSize', 4, 'color', [0.13, 0.55, 0.13])
hold on;
plot(x800, data800, '-+k','LineWidth',2, 'MarkerSize', 4, 'color', [0.1, 0.1, 0.44])
hold on;
plot(sx800, sdata800, '-.ko', 'LineWidth',2, 'MarkerSize', 4, 'color', [0.1, 0.1, 0.44])

xlabel('MSR'); % x轴注解

ylabel('Total fuel cost'); % y轴注解

title('Performance Stability'); % 图形标题

legend('CA = 740, real distribution','CA = 740, simulated distributoin', ...
    'CA = 770, real distribution','CA = 770, simulated distributoin', ...
    'CA = 800, real distribution','CA = 800, simulated distributoin'); % 图形注解

grid on; % 显示格线