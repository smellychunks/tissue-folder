function path = fullPath(animate2D,animate3D,writeVideo,skip)
%FULLPATH Generates folding paths for tissue folder
%   Northeastern Capstone Project Spring 2018
%   This function generates .h files referenced by the arduino control code
%   Function inputs are all booleans...
%   animate2D is 1x2 ; toggles 2D path animation of each axis
%   animate3D toggles 3D path animation of both axes
%   writeVideo hides the animations but writes them to a video file
clc;close all
disp('--Tissue Folder Path Generator--')

%% Manage Missing Function Inputs
if nargin < 1
    animate2D = [false false];
    animate3D = false;
    writeVideo = false;
    skip = false;
elseif nargin < 3
    writeVideo = false;
    skip = false;
elseif nargin < 4
    skip = false;
end
if size(animate2D,2) == 1
   animate2D = [animate2D animate2D]; 
end

%% *********************USER INPUTS BELOW*********************************
%% Basic Machine Geometry
in.x_length = 180; % Usable width of x axis rails
in.z_floor = 30;%-85.8; % Height of strip holder above baseplate when z bottoms out
in.z_length = 220; % Length of Z Axis (Only needed for top home)

%% Strip Geometry
strip_1_length = 250;%155;
strip_2_length = 250;%160;
in.strip_width = 10; % Strip Width
in.thk = .04; % Strip Thickness

%% Fold Tuning

% Control Points
in.dx_pre = -25;
in.dx_post = 15;

% Tension Factors (ex: with .98 the strip is 98% taut)
in.T_dock = .91;
in.T_pre = .98;
in.T_post = .98;

% Water Pump Settings
in.pump_speed = .6; % Run speed of pump (1 = max speed, 0 = stopped)
in.pump_time = .04; % Run time of pump for single squirt (seconds)
in.arm_rest = 180; % Resting angle of pump arm (degrees)
in.arm_active = 85; % Angle of pump when pump is active (degrees)

% Normal Folds
in.ds = in.strip_width + 2*in.thk; % Length used for normal folds
in.dh = 2*in.thk; % Height change of normal folds

% Initial Fold of Strip 1
ds0_1 = in.strip_width + 15; % Strip length used for initial fold
h0_1 = 0; % Height of stack after initial fold

% Initial Fold of Strip 2
ds0_2 = in.strip_width + 17; % Strip length used for initial fold
h0_2 = 0; % Height of stack after initial fold

%% Machine Specs
in.p = 12.7; % Lead Screw Height/Revolution
in.r1 = 9.525; % X Driving Gear Radius (.875" Diameter)
in.N1 = 24; % X Driving Gear Teeth
in.N2 = 28; % X Idling Gear Teeth
in.nstep = 200; % Motor Steps/Revolution
in.x_rpm_limit = 15; % X Motor Speed Limit (rpm)
in.z_rpm_limit = 15; % Z Motor Speed Limit (rpm)
% Z Ceiling Needed for top homing:
in.z_ceiling = floor( ( (abs(in.z_floor)+in.z_length) / in.p * in.nstep ) );
%% **********************USER INPUTS ABOVE*********************************

%% Generate Path for each strip

% Manage Unique Inputs
[in1,in2] = deal(in);
in1.strip_length = strip_1_length;
in2.strip_length = strip_2_length;
in1.ds0 = ds0_1;
in1.h0 = h0_1;
in2.ds0 = ds0_2;
in2.h0 = h0_2;

% Generate Paths
disp('Generating Paths...')
path1 = buildPath(in1);
path2 = buildPath(in2);

%% Write Controls to .h files for C++
path = mergePaths(path1,path2); % Combine paths to single structure
simulate(in,path,true); % Double check slack at control points
c = buildControls(in,removeWait(path)); % Modify structure for control output
parentFolder = fileparts(fileparts(mfilename('fullpath')));
arduinoFolder = 'ArduinoCode';
headerFolder = fullfile(parentFolder,arduinoFolder);
writeHeader(c,headerFolder); % Write files for c++
fprintf('Header Files Written to %s\n',headerFolder)

%% Animation of Strips Folding... request function inputs
if any([animate2D  animate3D])
    disp('Building Animations...')
    simPath = mergePaths(path1,path2,50); % Combine paths and interpolate
    simulate(in,simPath,false,animate2D,animate3D,writeVideo,skip);
end
disp('--Done--')
end