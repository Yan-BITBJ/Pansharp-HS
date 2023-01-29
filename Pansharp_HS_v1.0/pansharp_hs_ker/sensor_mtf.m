function mtf = sensor_mtf(sensor)

% sensor -- sensor name
% mtf -- single/multiple MTF value(s) 
% Ref.[1]: G. Vivone, et al., A benchmarking protocol for pansharpening: 
% Dataset, preprocessing, and quality assessment, IEEE JSTARS, 2021.

sensor = upper(sensor);

switch sensor
    case 'QB'
        mtf = [0.34,0.32,0.30,0.22]; % B/G/R/NIR
    case {'IK','IKONOS'}
        mtf = [0.26,0.28,0.29,0.28]; % B/G/R/NIR
    case {'GE','WV4','W4'}
        mtf = 0.23 * ones(1,4); % B/G/R/NIR
    case {'WV2','W2'}
        mtf = [0.35 * ones(1,7), 0.27]; % Coastal/B/G/Y/R/R edge/NIR/NIR2
    case {'WV3','W3'}
        mtf = [0.325 0.355 0.360 0.350 0.365 0.360 0.335 0.315]; % Coastal/B/G/Y/R/R edge/NIR/NIR2
    case 'SPOT7'
        mtf = 0.33 * ones(1,4); % B/G/R/NIR
    otherwise
        mtf = 0.3;        
end

end

