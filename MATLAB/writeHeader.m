function writeHeader(data,folder)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
if nargin<2
    folder = '';
end
names = fieldnames(data);
for i = 1:length(names)
   csvwrite(fullfile(folder,[names{i},'.h']),data.(names{i}))
end
end