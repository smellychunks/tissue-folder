function simulate(in,path,check,animate2D,animate3D,writeVideo)
%SIMULATE Simulates hanging strips with catenary curves
%   check: if true, error is thrown if there's not enough slack
%   animate2D: plays animation of 2D fold (2x1 bool; carriages independent)
%   animate3D: plays animation of both strips folding in 3D
if nargin<4
    animate2D = [false false];
    [animate3D,writeVideo] = deal(false); 
end
[short1, short2] = deal(false(path.folds,path.points));
[path.cats1, path.cats2] = deal(cell(path.folds,path.points));
np = 100; % number of catenary points
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

if ( any(any(short1)) || any(any(short2)) ) && check
    error('NOT ENOUGH SLACK!')
end

% Play Animation
ffwd = 10;
framerate = 20;
for i = 1:2
   if animate2D(i)
       plotPath(path,i,ffwd,framerate,writeVideo);
   end
end
if animate3D
    fold3D(path,in.strip_width,ffwd,framerate,writeVideo)
end
end