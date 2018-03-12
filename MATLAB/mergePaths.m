function out = mergePaths(path1,path2,len)
%MERGEPATHS Combines path data structures and creates running time vector
%   Resamples path data for evenly spaced time vector with option len input
    
tMat = path1.t;
names = fieldnames(path1);
nj = 2*size(tMat,1);
row = ones(1,size(tMat,2));

if nargin<3
    len = length(row);
    resample = false;
else
    resample = true;
end

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
                tq = path1.t(k,:)-path1.t(k,1)+runtime;
            else
                tq = path2.t(k,:)-path2.t(k,1)+runtime;
            end
            t = linspace(tq(1),tq(end),len);
            runtime = tq(end);
        if i==1
            out.t(j,:) = t;
        end
        if resample
            out.([names{i},'1'])(j,:) = interp1(tq,x01,t);
            out.([names{i},'2'])(j,:) = interp1(tq,x02,t);
        else
            out.([names{i},'1'])(j,:) = x01;
            out.([names{i},'2'])(j,:) = x02;
        end
    end
end
out.folds = size(out.t,1);
out.points = size(out.t,2);
end

