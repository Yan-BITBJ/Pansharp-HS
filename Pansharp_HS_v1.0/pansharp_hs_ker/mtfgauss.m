function [h,Hd] = mtfgauss(fc,mtf,N)

% MTF-matched filters using Gaussian kernel
% 
% INPUTS:
% fc -- Nyquist freq. half of sampling freq.
% mtf -- MTF value at fc
% N -- filter size = N+1, N being even is preferred 
%
% OUTPUTS:
% h -- filter coefficients
% Hd -- freq. response
% 
% An alternative approach is provided by the Ref. [1,2], see MTF/MTF_PAN
% A slight difference is that the length N in MTF/MTF_PAN is preferred to be odd
% and the sigma is normalized by N in an earlier version (see Ref.[1]).
% If the sigma is normalized by N-1 (as modified by recent version, see Ref.[2]), 
% then two approaches are identical.
% The design of MTF-based filters is also discussed in Ref.[3].
% see also mtftest.m
% 
% Ref.[1]: G. Vivone, et al., A critical comparison among pansharpening algorithms,
% IEEE TGRS, 2015.
% Ref.[2]: G. Vivone, et al., A new benchmark based on recent advances in multispectral 
% pansharpening: Revisiting pansharpening with classical and emerging pansharpening methods,
% IEEE TGRS, 2021.
% Ref.[3]: A. Kallel, MTF-Adjusted Pansharpening Approach Based on Coupled
% Multiresolution Decompositions, IEEE TGRS, 2015.
% Note the sigma in Ref.[3] is not actually the same as that in this function. 
% Actually, the sigma here is in frequency domain, whereas the sigma in Ref.[3] is given in spatial domain.

% determine the sigma of freq. response
sig = fc/sqrt(-2*log(mtf));

% freq. sampling
fs = 1/N;
x = -1/2:fs:1/2;  % within a period
Hd = exp(-x.^2/2/sig^2);
Hd = Hd'*Hd;

% filter design
h = fwind1(Hd,kaiser(N+1));

% show the freq. response
%freqz2(h)

