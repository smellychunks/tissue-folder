function plotPath(path,ax,ffwd,framerate,makeMovie,skip)
%PLOTPATH Plots folding path in 2D

x = path.(['x',num2str(ax)]);
cats = path.(['cats',num2str(ax)]);
z1 = path.(['z',num2str(ax)]);
t = path.t;

h = figure('units','normalized','outerposition',[0 0 1 1]);
clf
axis equal manual

xlim([min(min(x)),max(max(x))])
ylim([-40,max(max(z1))+20])
title(sprintf('Axis %d Folding',ax))
strip = line(0,0,'LineWidth',2);
hold on
ends = scatter(0,0,80,'ko','filled');
track =  line(0,0,'LineWidth',1,'linestyle',':','color','k');
dt = mean(mean(diff(t,2)))/ffwd;
grid on
xlabel('X Position')
ylabel('Z Position')
set(gca,'fontsize',18)
xtrack = [];
ytrack = [];
if makeMovie
    set(h,'visible','off')
    filename = sprintf('Axis %d Folding.avi',ax);
    v = VideoWriter(filename);
    v.FrameRate=framerate;
    open(v)
end
if skip
    jList = [1 path.points];
else
    jList = 1:path.points;
end
for i = 1:path.folds
    disp(i)
    plot(cats{i,1}(:,1),cats{i,1}(:,2),'k-','linewidth',1)
    for j = jList
        set(strip,'xdata',cats{i,j}(:,1),'ydata',cats{i,j}(:,2))
        set(ends,'xdata',[cats{i,j}(1,1) cats{i,j}(end,1)],...
            'ydata',[cats{i,j}(1,2),cats{i,j}(end,2)])
        xtrack = [xtrack, x(i,j)]; %#ok<AGROW>
        ytrack = [ytrack, z1(i,j)]; %#ok<AGROW>
        if ~skip
            set(track,'xdata',xtrack,'ydata',ytrack)
        end
        drawnow
        if makeMovie
            writeVideo(v,getframe(gcf))
        end
        pause(dt)
    end
    plot(cats{i,end}(:,1),cats{i,end}(:,2),'k-','linewidth',1)
end
if makeMovie
    close(v)
end
end

