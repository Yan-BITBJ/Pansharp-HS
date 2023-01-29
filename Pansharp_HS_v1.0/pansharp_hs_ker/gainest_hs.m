function g = gainest_hs(lrms,pan,pL,mth,varargin)

% HS injection model
% 
% INPUTS:
% lrms -- upsampled MS
% pan -- original PAN (single/multiple-band)
% pL -- LR PAN (single/multiple-band)
% mth:
% 'HS-ITER' -- g∞ = <MS,D>/<PL,D>, D = PAN-PL
% 'HS-WLS' -- linear combination of est. g** (weighted g∞) and g∞
% 'HS-HPM' -- HS with HPM-like REF
% varargin -- local size for WLS estimation
%
% OUTPUT:
% g -- injection gains

if size(pan,3)~=size(lrms,3)
    pan = repmat(pan,1,1,size(lrms,3));
end

if size(pL,3)~=size(lrms,3)
    pL = repmat(pL,1,1,size(lrms,3));
end

d = pan-pL;

typ = 'cov'; % projection type
switch upper(mth)
    case 'HS-ITER'
        g = gainproj(lrms,d,pL,d,typ);
    case 'HS-WLS'
        ginf = gainproj(lrms,d,pL,d,typ);
        if nargin > 4
            siz = varargin{:};
        else
            siz = 3;
        end
        w = gainproj(pan,pL,pL,pL,'corloc',siz); % weight estimation
        msw = w.*lrms;
        pLw = w.*pL;
        gwls = gainproj(msw,d,pLw,d,typ);
        alpha = gainproj(pan,d,d,d,typ);
        g = alpha.*gwls+(1-alpha).*ginf;
    case 'HS-HPM'
        w = lrms./pL; % HPM-like weight
        dw = w.*d;
        g = gainproj(dw,d,d,d,typ);
    otherwise
        g = ones(1,size(lrms,3));
end

g = reshape(g,1,1,size(lrms,3));
