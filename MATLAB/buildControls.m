function c = buildControls(in,path)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
[~, a] = min(abs(path.x1(1,:) - in.a));
[~, b] = min(abs(path.x1(1,:) - in.b));

c.speed_limit = 200/60*[in.x_rpm_limit in.z_rpm_limit]; % steps/sec
for i = 1:2
    xi = ['x',num2str(i)];
    zi = ['z',num2str(i)];
    c.([xi zi '_start']) = [path.(['step_' xi])(1,1) path.(['step_' zi])(1,1)];
    c.([xi zi '_length']) = [in.([xi '_length']) in.([zi '_length'])];
    xz = {xi,zi};
    for j = 1:2
        c.([xz{j},'_pre']) = path.(['step_' xz{j}])(:,a)';
        c.([xz{j},'_post']) = path.(['step_' xz{j}])(:,b)';
        c.([xz{j},'_dock']) = path.(['step_' xz{j}])(:,end)';
    end
end

end