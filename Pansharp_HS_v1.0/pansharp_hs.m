function fus = pansharp_hs(lrms,pan,mth,ratio,sensor,samp)

% A injection-based pansharpening method using hybrid-scale (HS) estimation 
% version 1.0  2023/1/29
% Ref.[1]: Yan Shi, Aiyong Tan, Na Liu, Wei Li, Ran Tao, Jocelyn Chanussot, 
% A Pansharpening Method based on Hybrid-Scale Estimation of Injection Gains, IEEE TGRS, 2023.
% Copyright (c) 2023
% All rights reserved.
% 
% INPUTS:
% lrms -- LRMS, upsampled MS to PAN scale
% pan -- original PAN
% mth -- HS model: HS-ITER/HS-WLS/HS-HPM
% ratio -- ration of spatial resolution of PAN and MS
% sensor -- specified sensor for MTF
% samp -- 1/0, subsampled or not in GLP
%
% OUTPUT:
% fus -- fused MS


% LR PAN
mtf = sensor_mtf(sensor);
pL = pandeg(pan,ratio,mtf);
if samp == 1
    intp_mth = 'nearest';
    pL = imresize(pL,1/ratio,intp_mth);
    pL = interp23tap(pL,ratio);
end

% HM preprocessing
[pL,a,b] = panhm(pL,lrms,'std');
pan = a.*pan+b;

% detail extraction
D = pan-pL;

% HS estimation of injection gains 
g = gainest_hs(lrms,pan,pL,mth);

fus = lrms+g.*D;

end

