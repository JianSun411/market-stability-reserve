name = 'C:\Users\22390\Desktop\accpm\9_generator_118_MSR\9_gen_118data_quantile.mat';
storage_name = 'C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\9_gen_118storage_data.mat';
ratio = 1.724889938939865e+02;
c1 = [0.25 0.41 0.88];
c2 = [1 0.39 0.28];

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\9_gen\9_gen_CA_6200.mat');
y1 = data.MSR;
x1 = data.S_C;
z1 = get_z(name, data.X);

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\9_gen\9_gen_CA_6500.mat');
y2 = data.MSR;
x2 = data.S_C;
z2 = get_z(name, data.X);

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\9_gen_20_80_4_high.mat');
y3 = get_used_B(storage_name, data.x_records, 1, data.B_list);
x3 = data.social_cost+ ratio * y3; 
z3 = get_z(name, data.x_records);

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\9_gen_20_80_4_medium.mat');
y4 = get_used_B(storage_name, data.x_records, 0.75, data.B_list);
x4 = data.social_cost+ ratio * y4; 
z4 = get_z(name, data.x_records);

data = load('C:\Users\22390\Desktop\accpm\new_fuwuqi_data\storage\9_gen_20_80_4_low.mat');
y5 = get_used_B(storage_name, data.x_records, 0.5, data.B_list);
x5 = data.social_cost+ ratio * y5; 
z5 = get_z(name, data.x_records);


% ----------------- 创建笛卡尔（直角）坐标系一
h_ap=axes('Position',[0.13,0.13,0.7,0.75]); 			%<4>
% ----------------- 设置坐标轴颜色、范围、间隔，开启网格
x_l = min([x1, x2]);
x_r = max([x1, x2]);
y_l = min([z1, z2]);
y_u = max([z1, z2]);
set(h_ap,'Xcolor',c1,'Ycolor',c1,'Xlim',[x_l * 0.999,x_r*1.01],'Ylim',[y_l * 0.99,y_u * 1.01]);
% nx=10;ny=6; 											%<6>
% pxtick=0:((5-0)/nx):5;pytick=0:((15-0)/ny):15; 			%<7>
set(h_ap,'Xgrid','on','Ygrid','on')%'Xtick',pxtick,'Ytick',pytick,
set(get(h_ap,'Xlabel'),'String',' social cost \rightarrow ($) ')
set(get(h_ap,'Ylabel'),'String',' carbon emission \rightarrow (ton)')
% ----------------- 添加图形
line(x1,z1,'Color',c1, 'linestyle', '-', 'Marker', '+', 'linewidth', 1.2); 	
for i = linspace(1, length(x1), length(x1))
    text(x1(i)-(x_r - x_l)*0.07,z1(i)-(y_u - y_l)*0.01,num2str(round(y1(i))),'FontSize',10, 'color', c1)
end
line(x2,z2,'Color',c1, 'linestyle', '--', 'Marker', '+', 'linewidth', 1.2); 
for i = linspace(1, length(x2), length(x2))
    text(x2(i)-(x_r - x_l)*0.07,z2(i)-(y_u - y_l)*0.01,num2str(round(y2(i))),'FontSize',10, 'color', c1)
end
legend(h_ap, 'CA = 6200 ton', 'CA = 6500 ton', 'Location', 'southwest')
strs = 'MSR value';
annotation('textbox',[0.18,0.25,0.14,0.05],'LineStyle','-','LineWidth',0.3, 'String',strs, 'color', c1, 'EdgeColor', c1)

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
set(h_at,'Ylim',[y_l * 0.99, y_u * 1.01]) 	
set(h_at,'Xlim',[x_l * 0.95, x_r * 1.01])%<18>
set(get(h_at,'Xlabel'),'String','social cost \rightarrow ($) ')
set(get(h_at,'Ylabel'),'String','carbon emission \rightarrow (ton) ')
% ----------------- 添加图形
line(x3,z3,'Color',c2,'Parent',h_at, 'linewidth', 1.2, 'Marker', '+', 'linestyle','-') 	
for i = linspace(1, length(x3), length(x3))
    text(x3(i)-(x_r - x_l)*0.1,z3(i)+(y_u - y_l)*0.03,num2str(round(y3(i))),'FontSize',10, 'color', c2, 'Rotation', 0)
end
line(x4,z4,'Color',c2,'Parent',h_at, 'linewidth', 1.2, 'Marker', '+', 'linestyle','--') 
for i = linspace(1, length(x4), length(x4))
    text(x4(i)-(x_r - x_l)*0.07,z4(i)+(y_u - y_l)*0.01,num2str(round(y4(i))),'FontSize',10, 'color', c2, 'Rotation', 0)
end
line(x5,z5,'Color',c2,'Parent',h_at, 'linewidth', 1.2, 'Marker', '+', 'linestyle','-.') 
for i = linspace(1, length(x5), length(x5))
    text(x5(i)-(x_r - x_l)*0.08,z5(i)+(y_u - y_l)*0.1,num2str(round(y5(i))),'FontSize',10, 'color', c2, 'Rotation', 0)
end
legend(h_at, 'high s_0', 'medium s_0', 'low s_0')
strs = 'Used Storage';
annotation('textbox',[0.65,0.63,0.17,0.05],'LineStyle','-','LineWidth',0.3, 'String',strs, 'color', c2, 'EdgeColor', c2)
title('System 2')
% % ----------------- 设置坐标间隔
% xpm=get(h_at,'Xlim'); 									%<20>添加图形后才能得到Xlim
% txtick=xpm(1):((xpm(2)-xpm(1))/nx):xpm(2); 				%<21>
% tytick=0:((210-0)/ny):210; %<22>
% set(h_at,'Xtick',txtick,'Ytick',tytick) 				%<23>

