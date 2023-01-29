function [panh,a,b] = panhm(pan,lrms,mth,varargin)

% histogram matching between PAN and MS
%
% INPUTS:
% pan -- original PAN
% ms -- upsampled MS
% mth -- HM methods: 
% varargin -- block size for local HM
%
% OUTPUS:
% panh = a*pan+b
% see also histmatch

B1 = size(pan,3);
B2 = size(lrms,3);

if B1<B2
    pan = repmat(pan,1,1,B2);
end

for i=1:B2
    if nargin > 3
        blk = varargin{:};
        [panh(:,:,i),a(:,:,i),b(:,:,i)] = histmatch(pan(:,:,i),lrms(:,:,i),mth,blk);
    else
        [panh(:,:,i),a(:,:,i),b(:,:,i)] = histmatch(pan(:,:,i),lrms(:,:,i),mth);
    end
end

