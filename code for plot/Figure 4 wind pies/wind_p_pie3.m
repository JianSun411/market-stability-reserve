clear;
c1 = [83 120 227]/255;
c2 = [255 114 89]/255;
c3 = [136 233 134]/255;
set(gcf,'position',[200 200 1000 400])
% h_ap=axes('Position',[0.13,0.13,0.7,0.75]);

load('wind_p_data.mat')
X1(5:10, 2) = max(X1(5:10, 2), 0);
X2(5:10, 2) = max(X2(5:10, 2), 0);
X3(5:10, 2) = max(X3(5:10, 2), 0);
tnp1 = max(sum(X1, 2));
tnp2 = max(sum(X2, 2));
tnp3 = max(sum(X3, 2));
biaozhun = max([tnp1, tnp2, tnp3]);

X = X1;
new_X = zeros(10,2);
h = cell(1, 10);
for i = linspace(1, 10, 10)
    new_X(i, :) = X(i, :)/sum(X(i, :));
    h{i} = subplot(3,10,i);
    p = pie3(new_X(i, :));
    p(2).FaceColor = c3;
    p(3).FaceColor = c3;
    p(4).FontSize = 20;
    if i < 5
        p(6).FaceColor = c1;
        p(7).FaceColor = c1;
        p(8).FontSize = 20;
    elseif new_X(i, 2)>0
        p(6).FaceColor = c2;
        p(7).FaceColor = c2;
        p(8).FontSize = 20;
    end
end
tnp = sum(X, 2);
tnp = tnp/biaozhun;
for i = linspace(1, 10, 10)
    set(h{i},'position',[0.1 * (i-1), 0.8, 0.15*tnp(i),tnp(i)])
end

X = X2;
new_X = zeros(10,2);
h = cell(1, 10);
for i = linspace(1, 10, 10)
    new_X(i, :) = X(i, :)/sum(X(i, :));
    h{i} = subplot(3,10,10 + i);
    p = pie3(new_X(i, :));
    p(2).FaceColor = c3;
    p(3).FaceColor = c3;
    p(4).FontSize = 20;
    if i < 5
        p(6).FaceColor = c1;
        p(7).FaceColor = c1;
        p(8).FontSize = 20;
    elseif new_X(i, 2)>0
        p(6).FaceColor = c2;
        p(7).FaceColor = c2;
        p(8).FontSize = 20;
    end
end
tnp = sum(X, 2);
tnp = tnp/biaozhun;
for i = linspace(1, 10, 10)
    set(h{i},'position',[0.1 * (i-1), 0.5, 0.15*tnp(i),tnp(i)])
end

X = X3;
new_X = zeros(10,2);
h = cell(1, 10);
for i = linspace(1, 8, 8)
    new_X(i, :) = X(i, :)/sum(X(i, :));
    h{i} = subplot(3,10,20 + i);
    p = pie3(new_X(i, :));
    p(2).FaceColor = c3;
    p(3).FaceColor = c3;
    p(4).FontSize = 20;
    if i < 5
        p(6).FaceColor = c1;
        p(7).FaceColor = c1;
        p(8).FontSize = 20;
    elseif new_X(i, 2)>0
        p(6).FaceColor = c2;
        p(7).FaceColor = c2;
        p(8).FontSize = 20;
    end
end
tnp = sum(X, 2);
tnp = tnp/biaozhun;
for i = linspace(1, 8, 8)
    set(h{i},'position',[0.1 * (i-1), 0, 0.15*tnp(i),tnp(i)])
end
%下面的代码在智能对齐之后用
s = 20;
for i = linspace(1, 10, 10)
    annotation('textbox', [0.1 * (i-1)+0.05,0.15, 0.2, 0.2],'String', num2str(round(X(i, 1))),...
        'FontSize',s, 'EdgeColor', 'none')
end
annotation('textbox', [0.05,0.25, 0.2, 0.2],'String', 'CA = 6000','FontSize',s, 'EdgeColor', 'none')
annotation('textbox', [0.45,0.25, 0.2, 0.2],'String', 'high s_0','FontSize',s, 'EdgeColor', 'none')

annotation('textbox', [0.05,0.35, 0.2, 0.2],'String', 'MSR = 80','FontSize',s, 'EdgeColor', 'none')
annotation('textbox', [0.65,0.35, 0.2, 0.2],'String', 'B = 100','FontSize',s, 'EdgeColor', 'none')

annotation('rectangle',[.6 0.1 .04 .05],'FaceColor',c3)
annotation('rectangle',[.5 0.1 .04 .05],'FaceColor',c1)
annotation('rectangle',[.4 0.1 .04 .05],'FaceColor',c2)
annotation('textbox',[.1 0 .2 .5],'String','wind generation','FontSize',s, 'EdgeColor', 'none');
annotation('textbox',[.2 0 .2 .5],'String','equipped generator','FontSize',s, 'EdgeColor', 'none');
annotation('textbox',[0 0 .2 .5],'String','storage','FontSize',s, 'EdgeColor', 'none');





