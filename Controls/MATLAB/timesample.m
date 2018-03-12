function out = timesample(path1,path2,len)
%TIMESAMPLE Resamples path data for evenly spaced time vector
%   Returns path data with row lengths len
tMat = path1.t;
names = fieldnames(path1);
nj = 2*size(tMat,1);
row = ones(1,size(tMat,2));
for i = 1:length(names)
    if strcmp(names{i},'t'),continue,end
    out.([names{i},'1']) = zeros(nj,len);
    out.([names{i},'2']) = zeros(nj,len);
    runtime = 0;
    for j = 1:nj
        k = ceil(j/2);
        odd = mod(j,2)>0;
        if strcmp(names{i},'h')
            if odd
                out.h1(j) = path1.h(k);
            else
                out.h2(j) = path2.h(k);
            end
            continue
        end
        if odd
            x01 = path1.(names{i})(k,:);
            x02 = path2.(names{i})(k,1)*row;
        else
            x01 = path1.(names{i})(k,end)*row;
            x02 = path2.(names{i})(k,:);
        end
            if odd
                vq = path1.t(k,:)-path1.t(k,1)+runtime;
            else
                vq = path2.t(k,:)-path2.t(k,1)+runtime;
            end
            v = linspace(vq(1),vq(end),len);
            runtime = vq(end);
        if i==1
            out.t(j,:) = v;
        end
            out.([names{i},'1'])(j,:) = interp1(vq,x01,v);
            out.([names{i},'2'])(j,:) = interp1(vq,x02,v);
    end
end
out.folds = size(out.t,1);
out.points = size(out.t,2);
end

