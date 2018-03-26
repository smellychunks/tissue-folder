function writeHeader(data,folder)
%WRITEHEADER Writes a .h (C++) file for each field in data structure
if nargin<2
    folder = '';
end
names = fieldnames(data);
for i = 1:length(names)
   csvwrite(fullfile(folder,[names{i},'.h']),data.(names{i}))
end
end