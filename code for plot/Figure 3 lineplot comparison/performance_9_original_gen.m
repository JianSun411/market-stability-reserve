clear;
name = '118data_quantile.mat';
storage_name = 'C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\118storage_data.mat';
ratio = 1.724889938939865e+02;
c1 = [0.25 0.41 0.88];
c2 = [1 0.39 0.28];

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\9_original_gen\test_acc_CA_8200_MSR_25-75-6.mat');
y1 = data.MSR_list;
original_x1 = data.social_cost;
original_z1 = get_z(name, data.x_records);

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\9_original_gen\9_original_gen_CA_8500.mat');
y2 = data.MSR;
original_x2 = data.S_C;
original_z2 = get_z(name, data.X);

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\9_original_gen_20_200_10_high.mat');
y3 = get_used_B(storage_name, data.x_records, 1, data.B_list);
x3 = data.social_cost+ ratio * y3; 
z3 = get_z(name, data.x_records);
x3 = x3(1:end-3);
y3 = y3(1:end-3);
z3 = z3(1:end-3);

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\9_original_gen_20_200_10_medium.mat');
y4 = get_used_B(storage_name, data.x_records, 0.75, data.B_list);
x4 = data.social_cost+ ratio * y4; 
z4 = get_z(name, data.x_records);

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\9_original_gen_20_200_10_low.mat');
y5 = get_used_B(storage_name, data.x_records, 0.5, data.B_list);
x5 = data.social_cost+ ratio * y5; 
z5 = get_z(name, data.x_records);

% ----------------- 创建笛卡尔（直角）坐标系一
h_ap=axes('Position',[0.13,0.13,0.7,0.75]); 			%<4>
% ----------------- 设置坐标轴颜色、范围、间隔，开启网格
set(h_ap,'Xcolor',c1,'Ycolor',c1, 'Xgrid','on','Ygrid','on'); 
set(get(h_ap,'Xlabel'),'String',' social cost \rightarrow ($) ')
set(get(h_ap,'Ylabel'),'String',' carbon emission \rightarrow (ton)')
% ----------------- 添加图形
x_break_start = max(original_x2);
x_break_end = min(original_x1);
y_break_start = max(original_z1);
y_break_end = min(original_z2);
x1 = original_x1 - (x_break_end - x_break_start)*0.95;
z1 = original_z1;
x2 = original_x2;
delta_y = round((y_break_end - y_break_start)*0.95) + 1;
z2 = original_z2 - delta_y;
xlim_l = min(x2)*0.9999;
xlim_r = max(x1)*1.0001+300;
ylim_l = min(z1)* 0.999;
ylim_u = max(z2)*1.001+20;
set(h_ap,'Xlim',[xlim_l ,xlim_r],'Ylim',[ylim_l,ylim_u]); %设置坐标轴范围
line(x1,z1,'Color',c1, 'linestyle', '-', 'Marker', '+', 'linewidth', 1.2); 	
for i = linspace(1, length(x1), length(x1))
    text(x1(i),z1(i),num2str(round(y1(i))),'FontSize',10, 'color', c1)
end
line(x2,z2,'Color',c1, 'linestyle', '--', 'Marker', '+', 'linewidth', 1.2); 
for i = linspace(1, length(x2), length(x2))
    text(x2(i),z2(i),num2str(round(y2(i))),'FontSize',10, 'color', c1)
end
legend(h_ap, 'CA = 8200 ton', 'CA = 8500 ton', 'Location', 'southwest')
strs = 'MSR value';
annotation('textbox',[0.18,0.25,0.14,0.05],'LineStyle','-','LineWidth',0.3, 'String',strs, 'color', c1, 'EdgeColor', c1)

% 设置横轴截断
xlimit=get(gca,'xlim');
x_interval = (xlimit(2)-xlimit(1))/8;
adjust_value_x = 0.4*x_interval;
ylimit=get(gca,'ylim');
y_interval = 20;
adjust_value_y = 0.4*y_interval;
location_X=(x_break_start + adjust_value_x -xlimit(1))/(xlim_r - xlim_l);
t1=text(location_X, 0,'//','sc','Color', c1,'BackgroundColor', 'w','margin',eps, 'fontsize',13);
location_Y=(y_break_start + adjust_value_y -ylimit(1))/(ylim_u - ylim_l);
t2=text(-eps, location_Y, '//','sc','Color',c1,'BackgroundColor', 'w','margin',eps, 'fontsize',13);

% 重新定义横坐标刻度
xtick=xlimit(1):x_interval:xlimit(2);
set(gca,'xtick',xtick);
xtick(xtick>x_break_start+eps)=xtick(xtick>x_break_start+eps)+(x_break_end - x_break_start)*0.95;
xtick = xtick/10^5;
for i=1:length(xtick)
   xticklabel{i}=sprintf('%.4g',xtick(i));
end
set(gca,'xTickLabel', xticklabel);
text(xlimit(1),ylimit(1),'\times10^5','FontSize',10, 'color', c1)

ytick=8220:y_interval:8360;
set(gca,'ytick',ytick);
ytick(ytick>y_break_start+eps)=ytick(ytick>y_break_start+eps)+delta_y;
for i=1:length(ytick)
   yticklabel{i}=sprintf('%g',ytick(i));
end
set(gca,'yTickLabel', yticklabel); %修改坐标名称、字体







% ----------------- 创建坐标系二
h_at=axes('Position',get(h_ap,'Position')); 			%<12>
% ----------------- 设置坐标轴颜色、范围
set(h_at,'Color','none','Xcolor',c2,'Ycolor',c2); 	%<13>
set(h_at,'Xaxislocation','top') 						%<14>
set(h_at,'Yaxislocation','right')%'Ydir','rev' %降序
y_l = min([z3, z4, z5]);
y_u = max([z3, z4, z5]);
x_l = min([x3, x4, x5]);
x_r = max([x3, x4, x5]);
set(h_at,'Ylim',[y_l * 0.99, y_u * 1.005]) 	
set(h_at,'Xlim',[x_l * 0.95, x_r * 1.01])%<18>
set(get(h_at,'Xlabel'),'String','social cost \rightarrow ($) ')
set(get(h_at,'Ylabel'),'String','carbon emission \rightarrow (ton) ')
% ----------------- 添加图形
line(x3,z3,'Color',c2,'Parent',h_at, 'linewidth', 1.2, 'Marker', '+', 'linestyle','-') 	
for i = linspace(1, length(x3), length(x3))
    text(x3(i),z3(i),num2str(round(y3(i))),'FontSize',10, 'color', c2, 'Rotation', 0)
end
line(x4,z4,'Color',c2,'Parent',h_at, 'linewidth', 1.2, 'Marker', '+', 'linestyle','--') 
for i = linspace(1, length(x4), length(x4))
    text(x4(i),z4(i),num2str(round(y4(i))),'FontSize',10, 'color', c2, 'Rotation', 0)
end
line(x5,z5,'Color',c2,'Parent',h_at, 'linewidth', 1.2, 'Marker', '+', 'linestyle','-.') 
for i = linspace(1, length(x5), length(x5))
    text(x5(i),z5(i),num2str(round(y5(i))),'FontSize',10, 'color', c2, 'Rotation', 0)
end
legend(h_at, 'high s_0', 'medium s_0', 'low s_0')
strs = 'Used Storage';
annotation('textbox',[0.65,0.63,0.17,0.05],'LineStyle','-','LineWidth',0.3, 'String',strs, 'color', c2, 'EdgeColor', c2)
title('System 1')
% % ----------------- 设置坐标间隔
% xpm=get(h_at,'Xlim'); 									%<20>添加图形后才能得到Xlim
% txtick=xpm(1):((xpm(2)-xpm(1))/nx):xpm(2); 				%<21>
% tytick=0:((210-0)/ny):210; %<22>
% set(h_at,'Xtick',txtick,'Ytick',tytick) 				%<23>

