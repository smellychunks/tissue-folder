function c = buildControls(in,path)
%BUILDCONTROLS Reformats input structure to be written as C++ input

c.speed_limit = 200/60*[in.x_rpm_limit in.z_rpm_limit]; % steps/sec
% Pump speed is 0-255 scale, pump time is in milliseconds
c.pump_settings = [min(255,round(in.pump_speed*255)) 1000*in.pump_time ];
for i = 1:2
    xi = ['x',num2str(i)];
    zi = ['z',num2str(i)];
    c.([xi zi '_start']) = [path.(['step_' xi])(1,1) path.(['step_' zi])(1,1)];
    xz = {xi,zi};
    for j = 1:2
        c.([xz{j},'_pre']) = path.(['step_' xz{j}])(:,2)';
        c.([xz{j},'_post']) = path.(['step_' xz{j}])(:,3)';
        c.([xz{j},'_dock']) = path.(['step_' xz{j}])(:,end)';
    end
end

end