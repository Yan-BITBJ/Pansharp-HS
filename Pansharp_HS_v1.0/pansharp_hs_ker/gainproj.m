function g = gainproj(A,B,C,D,typ,varargin)

% calculation of the projective injection gain
% A,B,C,D -- matrices with same size
% typ -- 'cov'/'cor'/'covloc'/'corloc'
% varargin -- local window size
% g -- projection coefficient

N = size(A,3); % number of bands 

for i = 1:N
    a = A(:,:,i);
    b = B(:,:,i);
    c = C(:,:,i);
    d = D(:,:,i);
    switch typ
        case 'cor'
            num = a.*b;
            den = c.*d;
            g(i) = sum(num(:))/(sum(den(:))+eps);
        case 'cov'
            m1 = cov(a,b);
            m2 = cov(c,d);
            g(i) = m1(1,2)/(m2(1,2)+eps);
        case 'corloc'
            if nargin>5
                siz = varargin{:};
            else
                siz = 3;
            end
            num = covfilt(a,b,siz,'cor');
            den = covfilt(c,d,siz,'cor');
            g(:,:,i) = num./(den+eps);
        case 'covloc'
            if nargin>5
                siz = varargin{:};
            else
                siz = 3;
            end
            num = covfilt(a,b,siz,'cov');
            den = covfilt(c,d,siz,'cov');
            g(:,:,i) = num./(den+eps);       
    end
end

    