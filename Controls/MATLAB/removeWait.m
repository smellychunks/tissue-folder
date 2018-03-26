function data = removeWait(data)
%REMOVEWAIT Removes rows where carriage sits and waits for other carriage
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

