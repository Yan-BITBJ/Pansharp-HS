 function C = covfilt(A,B,varargin)
 
 % local covariance/correlation/cc/cc variant of two matrices
 % A,B -- input matrices
 % C -- output matrix
 % if A = B, C is the local variance of A, which is equal to stdfilt(A).^2
 % varargin1 -- local window size, 3*3 by default
 % varargin2 -- 'cov'/'cor'/'cc'/'ccvar', 'cov' by default
 % cov -- E[AB] - E[A]E[B]
 % cor -- E[AB]
 % cc -- normalized covariance, cov(A,B)/std(A)std(B)
 % ccvar -- variant of cc, cov(A,B)/(var(A)+var(B))/2
 
 if ~isa(A,'double')
     A=double(A);
 end
 
 if ~isa(B,'double')
     B=double(B);
 end
 
 % local window
 if nargin>2 && isnumeric(varargin{1})
     w = varargin{1};
     if isscalar(w)
         w = ones(w);
     end
 else
     w = ones(3);
 end
 
 n = sum(w(:));
 wn = w/n;

% cov/cor/cc/ccvar
if nargin==3 && ischar(varargin{1})
    typ = varargin{1};
elseif nargin==4 && ischar(varargin{2})
    typ = varargin{2};     
else
    typ = 'cov';  
end

% padding, same as stdfilt
 exmode = 'symmetric'; 

switch typ
    case 'cor'       
        C = imfilter(A.*B,wn,exmode);
    case 'cov'
        C = imfilter(A.*B,wn,exmode);
        mA = imfilter(A,wn,exmode);
        mB = imfilter(B,wn,exmode);  
        C = C - mA.*mB;
    case 'cc'
        C = imfilter(A.*B,wn,exmode);
        mA = imfilter(A,wn,exmode);
        mB = imfilter(B,wn,exmode);  
        C = C - mA.*mB;
        ca = stdfilt(A,w);
        cb = stdfilt(B,w);
        C = C./(ca.*cb);
    case 'ccvar'
        C = imfilter(A.*B,wn,exmode);
        mA = imfilter(A,wn,exmode);
        mB = imfilter(B,wn,exmode);  
        C = C - mA.*mB;
        ca = stdfilt(A,w).^2;
        cb = stdfilt(B,w).^2;
        C = 2*C./(ca+cb);
end

C = C.*n/(n-1);
