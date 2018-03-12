function path = makePath(in)
%catPath Plots the path of a single strip
%   Returns path data in structure

close all;clc

%% Unpack input
strip_length = in.strip_length; % Strip Length
x_length = in.x_length; % Usable width of x axis rails
strip_width = in.strip_width; % Strip Width
p = in.p; % Lead Screw Pitch
r1 = in.r1; % X Driving Gear Radius
N1 = in.N1; % X Driving Gear Teeth
N2 = in.N2; % X Idling Gear Teeth
wc = in.wc; % Carriage Width
hc = in.hc; % Carriage Rail Height
% Motor Speed Limits (rpm)
x_rpm_limit = in.x_rpm_limit;
z_rpm_limit = in.z_rpm_limit;
nstep = in.nstep; % Steps per revolution
% Tuning Input
dsh0 = in.dsh0; % Extra Length added to initial fold
dsh = in.dsh; % Extra Length added to normal folds
dh0 = in.dh0; % Height change of initial fold
dh = in.dh; % Height change of normal folds
np = in.np; % Number of points to discretize x
ks = in.ks;
%% Derived Constants
xw_limit = pi/30 * x_rpm_limit;
zw_limit = pi/30 * z_rpm_limit;
radstep = 2*pi/nstep; % radians per step
a = in.a;
b = in.b;
ds0 = strip_width + dsh0; % strip length used for initial fold
ds = strip_width + dsh; % strip length used for normal folds
L0 = strip_length-ds0;
n = floor((L0-(x_length-strip_width)/2)/ds); % folds not including first
% waste = ds0 - strip_width + (x_length-strip_width)/2; % OUT OF DATE

%% Derived Vectors
i = (1:n)'; % index of each fold (after first)
h = dh0 + i*dh; % Height of each stack after each fold


%% Initialize X sweeping back and forth with each fold
x = x_length/2*[-1 a b 1];
s1 = [L0; L0 - i*ds]; % initial slack for each fold SHOULD I UPDATE TO BE 1 SHORTER?
s2 = s1-dsh;
s3 = s2-strip_width;
s4 = s1-ds;

x = repmat([x;fliplr(x)],ceil(n/2),1);
if mod(n,2)==1, x(end,:) = []; end

%% Booleans for indexing
left = x<a;
right = x>b;
folding = ~(left | right);
forward = mod(i,2).*ones(size(x,1),1);
reverse = ~forward;
before = left & forward | right & reverse;
after = right & forward | left & reverse;

%% Target X Location of Strip Bend
xp = x;
c = -strip_width/2;
d = strip_width/2;
xp(x<c) = c;
xp(x>d) = d;

plusminus = ones(n,2);
plusminus(1:2:end,1) = -1;
t1 = plusminus.*[wc/2,hc].*ones(n,2);
t4 = plusminus.*[-wc/2,hc].*ones(n,2);
%% Calculate slack and z position for each fold
[z,s,t] = deal(zeros(size(x)));
for i = 1:n
    % Determine z location based on catenary
    z1 = fitCatenary(x(i,1),[xp(i,1),h(i)],t1(i),s1(i));
    z4 = fitCatenary(x(i,end),[xp(i,end),h(i)],t4(i),s4(i));   
    z3 = sqrt((ks*s(i,folding(i,:))).^2-(xp(i,folding(i,:))-x(i,folding(i,:))).^2); % ADJUST FOLD LENGTH HERE
    z_before = linspace(z_start,z_folding(1),nnz(before(i,:))+1);
    z_before(end) = [];
    z_after = linspace(z_folding(end),z_end,nnz(after(i,:))+1);
    z_after(1) = [];
    z(i,:) = [z_before,z_folding,z_after];
end

%% Motor Angles and Speeds
theta_x = N2/(N1*r1) * x;
theta_z = z./p;
dt = max( abs(diff(theta_x,1,2))./xw_limit, abs(diff(theta_z,1,2))./zw_limit);

%% Build Time Vector
for i = 1:n
    if i==1
        t(i,1) = 0;
    else
        t(i,1) = t(i-1,end);
    end
    t(i,2:end) = cumsum(dt(i,:),2) + t(i,1);
end

%% Verify Adjusted Speeds
omega_x = [zeros(n,1) diff(theta_x,1,2)./dt];
omega_z = [zeros(n,1) diff(theta_z,1,2)./dt];
rpm_x = 60/(2*pi)*omega_x;
rpm_z = 60/(2*pi)*omega_z;
max_rpm_x = max(max(abs(rpm_x)));
max_rpm_z = max(max(abs(rpm_z)));
if max_rpm_x > x_rpm_limit+.001 || max_rpm_z > z_rpm_limit+.001
   warning('RPM Limit Exceeded!')
   disp(table(x_rpm_limit,max_rpm_x,z_rpm_limit,max_rpm_z))
end
step_x = floor(theta_x./radstep);
step_z = floor(theta_z./radstep);

%% Path Data Outputs
path.x = x;
path.z = z;
path.t = t;
path.s = s;
path.xp = xp;
path.theta_x = theta_x;
path.theta_z = theta_z;
path.step_x = step_x;
path.step_z = step_z;
path.rpm_x = rpm_x;
path.rpm_z = rpm_z;
path.h = h;
end