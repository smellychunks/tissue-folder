function fold3D(path, width, ffwd,framerate,makeMovie)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Variable Unpacking
x1 = path.x1;
x2 = path.x2;
cats1 = path.cats1;
cats2 = path.cats2;
z1 = path.z1;
z2 = path.z2;
t = path.t;

%% Base Matrix Initializations
b1m = ones(size(cats1{1,1}));
b0m = 0*b1m;
b1 = b1m(:,1);
b0 = b0m(:,1);
w = width/2*[-1 1].*b1;

%% Figure Initialization
h = figure('units','normalized','outerposition',[0 0 1 1]);
clf
c1 = [255 90 55] / 255;
c2 = [71 173 0] / 255;
strip1 = surf(b0m,w,b0m,'facecolor',c1,'edgecolor','none',...
    'facelighting','gouraud','ambientstrength',.75);
hold on
strip2 = surf(w,b0m,b0m,'facecolor',c2,'edgecolor','none',...
    'facelighting','gouraud','ambientstrength',.75);
ends1 = scatter3([0 0],[0 0],[0 0],80,'o','filled','markerfacecolor','k');
track1 =  plot3(0,0,0,'LineWidth',1,'linestyle',':','color',c1);
ends2 = scatter3([0 0],[0 0],[0 0],80,'o','filled','markerfacecolor','k');
track2 =  plot3(0,0,0,'LineWidth',1,'linestyle',':','color',c2);

dt = mean(mean(diff(t,2)))/ffwd;
grid on
view(45,15)
% view(0,0)
camproj('perspective')
title('Strip Folding')
xlabel('X1 Position (mm)')
ylabel('X2 Position (mm)')
zlabel('Z Position (mm)')
set(gca,'fontsize',18)
axis equal manual
xlim([min(min(x1)),max(max(x1))])
xl = xlim;
ylim(xl);
% yl = ylim;
zlim([-20,max(max(z1))+20])
% zl = zlim;

light%('Position',[xl(end) yl(end) zl(end)]);
x1track = [];
y1track = [];
z1track = [];
x2track = [];
y2track = [];
z2track = [];
if makeMovie
    set(h,'visible','off')
    v = VideoWriter('Strip Folding2.avi');
    v.FrameRate=framerate;
    open(v)
end
for i = 1:path.folds
    disp(i)
    plot3(cats1{i,1}(:,1),b0,cats1{i,1}(:,2),'--','linewidth',1,'color',c1)
    plot3(b0,cats2{i,1}(:,1),cats2{i,1}(:,2),'--','linewidth',1,'color',c2)
    for j = 1:path.points
        %% X1 Axis Updates
        set(strip1,'xdata',cats1{i,j}(:,1).*b1m,'zdata',cats1{i,j}(:,2).*b1m)
        set(ends1,'xdata',[cats1{i,j}(1,1) cats1{i,j}(end,1)],...
            'zdata',[cats1{i,j}(1,2),cats1{i,j}(end,2)])
        x1track = [x1track, x1(i,j)]; %#ok<AGROW>
        y1track = [y1track, 0]; %#ok<AGROW>
        z1track = [z1track, z1(i,j)]; %#ok<AGROW>
        set(track1,'xdata',x1track,'ydata',y1track,'zdata',z1track)
        %% X2 Axis Updates
        set(strip2,'ydata',cats2{i,j}(:,1).*b1m,'zdata',cats2{i,j}(:,2).*b1m)
        set(ends2,'ydata',[cats2{i,j}(1,1) cats2{i,j}(end,1)],...
            'zdata',[cats2{i,j}(1,2),cats2{i,j}(end,2)])
        x2track = [x2track, 0]; %#ok<AGROW>
        y2track = [y2track, x2(i,j)]; %#ok<AGROW>       
        z2track = [z2track, z2(i,j)]; %#ok<AGROW>
        set(track2,'xdata',x2track,'ydata',y2track,'zdata',z2track)
        %% Figure Refresh
        drawnow
        if makeMovie
            writeVideo(v,getframe(gcf))
        end
        pause(dt)
    end
    plot3(cats1{i,end}(:,1),b0,cats1{i,end}(:,2),'--','linewidth',1,'color',c1)
    plot3(b0,cats2{i,end}(:,1),cats2{i,end}(:,2),'--','linewidth',1,'color',c2)
end
if makeMovie
    close(v)
end
end

