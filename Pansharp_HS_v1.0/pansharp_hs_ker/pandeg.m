function output = pandeg(input,ratio,mtf,varargin)

% generation of the degraded PAN/MS by using MTF filters
% used for: 
% 1) LR PAN by MTF filters
% 2) RR evaluation 
% 3) RR estimation of injection gains
% 
% input -- original MS/PAN
% ratio -- scale ratio for degradation
% mtf -- single/multiple MTF value(s)
% varargin -- 1/0, sub-sampled or not
% output -- degraded MS/PAN, may multiple-band
% 
% see mtfgauss

fc = 1/2/ratio; % Nyquist freq.
N = 40; % filter size
%ex = 'symmetric';
ex = 'replicate'; % id. to MTF_GLP
band = size(input,3); % band num.
mtfnum = length(mtf); % mtf num.

if mtfnum>band
    input = repmat(input,1,1,mtfnum);
elseif mtfnum<band
    mtfnum = band;
    mtf = mtf * ones(1,mtfnum);
end

if mtfnum == 1 % single-band
    [h,~] = mtfgauss(fc,mtf,N);
    output = imfilter(input,h,ex); 
else % multiple-band
    output = zeros(size(input)); 
    for i=1:mtfnum
        [h,~] = mtfgauss(fc,mtf(i),N);
        output(:,:,i) = imfilter(input(:,:,i),h,ex);
    end
end

if nargin>3 && varargin{:}==1
    output = output(1:ratio:end,1:ratio:end,:);
end
