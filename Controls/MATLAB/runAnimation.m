function runAnimation(path,writeVideo)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 1
    writeVideo = false;
end
[short1, short2] = deal(false(path.folds,path.points));
[path.cats1, path.cats2] = deal(cell(path.folds,path.points));
for i = 1:path.folds
    for j = 1:path.points
        [xc1,zc1,short1(i,j)] = catenary([path.x1(i,j),path.z1(i,j)],...
            [path.v1(i,j),path.h1(i)],path.s1(i,j),np);
        path.cats1{i,j} = [xc1',zc1'];
        [xc2,zc2,short2(i,j)] = catenary([path.x2(i,j),path.z2(i,j)],...
            [path.v2(i,j),path.h2(i)],path.s2(i,j),np);
        path.cats2{i,j} = [xc2',zc2'];
    end
end

% Play Animation
ffwd = 5;
framerate = 20;
fold3D(path,in.strip_width,ffwd,framerate,writeVideo)
end

