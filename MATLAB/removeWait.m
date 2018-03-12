function data = removeWait(data)
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here
names = fieldnames(data);
for i = 1:length(names)
   if any(size(data.(names{i})) ~= size(data.t)) || strcmp(names{i},'t')
       continue
   end
   values = data.(names{i});
   waiting = abs(mean(diff(values,1,2),2)) > 0 * ones(size(values));
   values = reshape(values(waiting),[numel(values(waiting))./size(waiting,2),size(waiting,2)]);
   data.(names{i}) = values;
end
end

