function [xh,a,b] = histmatch(x,y,mth,varargin)

% histogram matching between two matrices x and y
% xh = a*x+b
% mth:
% 'std' a = std(y)/std(x), b = my - a*mx
% 'reg' a = cov(x,y)/var(x), b = my - a*mx 
% 'stdloc' -- local std
% 'regloc' -- local reg
% varargin -- local size

if size(x)~=size(y)
    error('size must be the same!');
end

switch mth
    case 'std'
        a = std2(y)/(std2(x)+eps);
        mx = mean(x(:));
        my = mean(y(:));
    case 'reg'
        c = cov(x,y);
        a = c(1,2)/(c(1,1)+eps);
        mx = mean(x(:));
        my = mean(y(:));
    case 'stdloc'
        if nargin>3
            siz = varargin{:};
        else
            siz =13;
        end
        blk = ones(siz);
        h = blk/sum(blk(:));
        a = stdfilt(y,blk)./(stdfilt(x,blk)+eps); 
        mx = conv2(x,h,'same');
        my = conv2(y,h,'same');
    case 'regloc'
        if nargin>3
            siz = varargin{:};
        else
            siz =13;
        end
        a = covfilt(x,y,siz)./(covfilt(x,x,siz)+eps);
        h = ones(siz);
        h = h/sum(h(:));
        mx = conv2(x,h,'same');
        my = conv2(y,h,'same');
end

b = my - a.*mx;
xh = a.*x+b;
