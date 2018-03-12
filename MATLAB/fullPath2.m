function path = fullPath(task)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin<1
    task = 'animation';
end
%% Inputs Common to Both Strips
% Basic Input
in.x_length = 180; % Usable width of x axis rails
in.strip_width = 10; % Strip Width
in.p = 3; % Lead Screw Pitch
in.r1 = 12.7; % X Driving Gear Radius
in.N1 = 12; % X Driving Gear Teeth
in.N2 = 16; % X Idling Gear Teeth
in.wc = 60; % Carriage Width
in.hc = 12; % Carriage Rail Height
% Motor Speed Limits (rpm)
in.x_rpm_limit = 50;
in.z_rpm_limit = 50;
in.nstep = 200;
% Tuning Input
foldMargin = 20;
in.b = in.strip_width/2 + foldMargin;
in.a = -in.b;
thk = .04; % Strip Thickness
in.ks = .99; % fold slack pct
in.dsh = 2*thk; % Extra Length added to normal folds

in.dh = 2*thk; % Height change of normal folds
in.np = 1000; % Number of points to discretize x
in.x1_length = -1;
in.z1_length = -1;
in.x2_length = -1;
in.z2_length = -1;
%% Individual Strip Inputs
[in1,in2] = deal(in);

% Strip Length
in1.strip_length = 350;
in2.strip_length = 350;

in1.dsh0 = 2; % Extra Length added to initial fold
in1.dh0 = 0; % Height change of initial fold
in2.k1 = 2.1; % Extra Length added to initial fold
in2.dh0 = thk; % Height change of initial fold

path1 = makePath(in1);
path2 = makePath(in2);

switch task
    case 'animation'
        path = mergePaths(path1,path2,100);
        [path.cats1, path.cats2] = deal(cell(path.folds,path.points));
        for i = 1:path.folds
            for j = 1:path.points
                [xc1,zc1] = catenary([path.x1(i,j),path.z1(i,j)],...
                    [path.xp1(i,j),path.h1(i)],path.s1(i,j),100);
                path.cats1{i,j} = [xc1',zc1'];
                [xc2,zc2] = catenary([path.x2(i,j),path.z2(i,j)],...
                    [path.xp2(i,j),path.h2(i)],path.s2(i,j),100);
                path.cats2{i,j} = [xc2',zc2'];
            end
        end
        ffwd = 5;
        framerate = 20;
        writeVideo = false;
        plotPath(path,ffwd,framerate,writeVideo)
    case 'control'
        path = mergePaths(path1,path2);
        c = buildControls(in,path);
        writeHeader(c,'ArduinoCode');
end
end

