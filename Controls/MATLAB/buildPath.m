function path = buildPath(in)
%BUILDPATH Finds folding path of single carriage

%% Fold Control Points
a = (in.x_length-in.strip_width)/2; % Leading edge of stack
b = in.x_length - a; % Trailing edge of stack
x_pre = a + in.dx_pre;
x_post = b + in.dx_post;
T = [in.T_dock in.T_pre in.T_post in.T_dock];

%% Initial Calculations
s0 = in.strip_length - in.ds0; % Strip length when auto-folding starts
n = floor( (s0 - a/in.T_dock) / in.ds ); % Number of folds to perform
h = in.h0 + (0:(n-1))'*in.dh - in.z_floor; % Height of stack
s_before = s0 - (0:(n-1))*in.ds; % Remaining strip before fold
s_after = s0 - (1:n)*in.ds; % Remaining strip after fold

%% Unit matrices used below
oneMat = ones(n,1);
threeMat = ones(n,3);
fourMat = ones(n,4);

%% Path Calculations
s = [s_before' .* threeMat, s_after'.* oneMat]; % Remaining strip length
x = [ 0 x_pre x_post in.x_length ] .* fourMat; % X Location of Folder
v = [ a a a b ] .* fourMat; % X Location of fold vertex
z = sqrt( (T.*s).^2 - (x-v).^2 ) + h; % Z Location of Folder

%% Adjust for Left vs Right Motion
evens = mod((1:n)',2) == 0;
x(evens,:) = in.x_length - x(evens,:);
v(evens,:) = in.x_length - v(evens,:);

%% Convert to Motor Steps
xw_limit = pi/30 * in.x_rpm_limit;
zw_limit = pi/30 * in.z_rpm_limit;
radstep = 2*pi/in.nstep; % radians per step

theta_x = in.N2/(in.N1*in.r1) * x;
theta_z = z/in.p; %% in rotations
step_x = floor(theta_x./radstep);
step_z = floor(theta_z.*in.nstep);
%%step_z = floor(theta_z./radstep);

%% Transform X so (0,0) is in the center
mid = in.x_length/2;
x = x - mid;
v = v - mid;
%% Build Time Vector
dt = max(abs(diff(theta_x,1,2))./xw_limit,abs(diff(theta_z,1,2))./zw_limit);
t = fourMat;
for i = 1:size(t,1)
    if i==1
        t(i,1) = 0;
    else
        t(i,1) = t(i-1,end);
    end
    t(i,2:end) = cumsum(dt(i,:),2) + t(i,1);
end

%% Structure assignments
path.x = x; path.z = z; path.s = s; path.v = v; path.h = h;
path.step_x = step_x; path.step_z = step_z; path.t = t;
end
