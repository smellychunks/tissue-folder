function [Y_END,X,Y] = fitCatenary(X_END,ORIGIN,TARGET,LENGTH,N_POINTS)
% FITCATENARY Fits a catenary given 2 points, one X, and a Length
%   Returns vectors with X and Y of catenary curve
if nargin<5 || N_POINTS<2
    N_POINTS = 100;
end
Y_MAX = sqrt(LENGTH^2 - (X_END - ORIGIN(1))^2 ) + ORIGIN(2);
Y_END = fminbnd(@hang,0,Y_MAX);
f = .98;
if Y_END>f*Y_MAX
    Y_END = f*Y_MAX;
end
[X,Y] = catenary(ORIGIN,[X_END,Y_END],LENGTH,N_POINTS);
    function R = hang(Y)
        [x,y] = catenary(ORIGIN,[X_END,Y],LENGTH,N_POINTS);
        [~,k] = min(abs(x-TARGET(1)));
        R = abs(TARGET(2) - y(k));
    end
end