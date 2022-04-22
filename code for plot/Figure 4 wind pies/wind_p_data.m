clear;

X1 = zeros(10, 2);
X2 = zeros(10, 2);
X3 = zeros(10, 2);
% %数据集一的MSR：9_original_gen_system
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_original_gen_CA_6000_MSR_80_160_3_p_0.98.mat');
name = 'C:\Users\22390\Desktop\accpm\118MSR\final_9_original_gen_118data_quantile.mat';
[X1(1, 1),X1(1, 2)] = get_generation(name, data.x_records(:, 1));
[X1(2, 1),X1(2, 2)] = get_generation(name, data.x_records(:, end));
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_original_gen_CA_6300_MSR_80_160_3_p_0.98.mat');
[X1(3, 1),X1(3, 2)] = get_generation(name, data.x_records(:, 1));
[X1(4, 1),X1(4, 2)] = get_generation(name, data.x_records(:, end));

% %数据集二的MSR：9_gen_system
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_gen_CA_4500_MSR_900_1100_5_p_0.98.mat');
name = 'C:\Users\22390\Desktop\accpm\9_generator_118_MSR\final_9_gen_118data_quantile.mat';
[X2(1, 1),X2(1, 2)] = get_generation(name, data.x_records(:, 1));
[X2(2, 1),X2(2, 2)] = get_generation(name, data.x_records(:, end));
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_gen_CA_4800_MSR_860_1020_5_p_0.98.mat');
[X2(3, 1),X2(3, 2)] = get_generation(name, data.x_records(:, 1));
[X2(4, 1),X2(4, 2)] = get_generation(name, data.x_records(:, end));

% %数据集三的MSR：8_gen
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_8_gen_CA_3200_MSR_2900_3300_5_p_0.98.mat');
name = 'C:\Users\22390\Desktop\accpm\8_generator_118_MSR\small_118data_quantile.mat';
[X3(1, 1),X3(1, 2)] = get_generation(name, data.x_records(:, 1));
[X3(2, 1),X3(2, 2)] = get_generation(name, data.x_records(:, end));
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_8_gen_CA_3500_MSR_2800_3300_6_p_0.98.mat');
[X3(3, 1),X3(3, 2)] = get_generation(name, data.x_records(:, 1));
[X3(4, 1),X3(4, 2)] = get_generation(name, data.x_records(:, end));


%数据集一的storage：
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_original_gen_20_100_5_high_p_0.98.mat');
name = 'C:\Users\22390\Desktop\accpm\storage\final_118storage_data.mat';
[X1(5, 1),X1(5, 2)] = get_generation(name, data.x_records(:, 1));
[X1(6, 1),X1(6, 2)] = get_generation(name, data.x_records(:, end));
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_original_gen_20_100_5_medium_p_0.98.mat');
[X1(7, 1),X1(7, 2)] = get_generation(name, data.x_records(:, 1));
[X1(8, 1),X1(8, 2)] = get_generation(name, data.x_records(:, end));
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_original_gen_20_100_5_low_p_0.98.mat');
[X1(9, 1),X1(9, 2)] = get_generation(name, data.x_records(:, 1));
[X1(10, 1),X1(10, 2)] = get_generation(name, data.x_records(:, end));

%数据集二的storage：
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_gen_20_100_5_high_p_0.98.mat');
name = 'C:\Users\22390\Desktop\accpm\storage\final_9_gen_118storage_data.mat';
[X2(5, 1),X2(5, 2)] = get_generation(name, data.x_records(:, 1));
[X2(6, 1),X2(6, 2)] = get_generation(name, data.x_records(:, end));
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_gen_20_100_5_medium_p_0.98.mat');
[X2(7, 1),X2(7, 2)] = get_generation(name, data.x_records(:, 1));
[X2(8, 1),X2(8, 2)] = get_generation(name, data.x_records(:, end));
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\final_9_gen_20_100_5_low_p_0.98.mat');
[X2(9, 1),X2(9, 2)] = get_generation(name, data.x_records(:, 1));
[X2(10, 1),X2(10, 2)] = get_generation(name, data.x_records(:, end));

%数据集三：
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\8_gen_300_400_6_high_p_0.98.mat');
name = 'C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\8_gen_118storage_data.mat';
[X3(5, 1),X3(5, 2)] = get_generation(name, data.x_records(:, 1));
[X3(6, 1),X3(6, 2)] = get_generation(name, data.x_records(:, end));
data = load('C:\Users\22390\Desktop\accpm\unified parameter2\8_gen_300_400_6_medium_p_0.98.mat');
[X3(7, 1),X3(7, 2)] = get_generation(name, data.x_records(:, 4));
[X3(8, 1),X3(8, 2)] = get_generation(name, data.x_records(:, end));

X1(5:10, 2) = - X1(5:10, 2);
X2(5:10, 2) = - X2(5:10, 2);
X3(5:10, 2) = - X3(5:10, 2);
%第二列负值表示storage没有出力，反而吸收了能源
save('wind_p_data.mat', 'X1', 'X2', 'X3')


