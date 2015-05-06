function [cloud, beta0, gamma0] = calibrate(scan, startPos, endPos, ...
    startAng, endAng, planesSeeds, distThreshold)
%CALIBRATE Calibrates the scanner by selecting beta0 and gamma0 that
%          minimize the loss function.
%   Calibrates the scanner by selecting the unknown scanner parameters
%   beta0 and gamma0 that minimize the loss function. The loss function
%   encodes the wellness of fit of the plane points in the cloud. The
%   computed parameters are used to map the scanned data to points in the
%   cartesian space.

    % Run simplex to minimize loss
    beta0_gamma0 = fminsearch(@(x) planesDistanceLoss(scan, startPos, ...
        endPos, startAng, endAng, x, planesSeeds, distThreshold), [0, 0]);

    % Use the computed beta0 and gamma0 to generate the final point cloud
    beta0 = beta0_gamma0(1);
    gamma0 = beta0_gamma0(2);
    cloud = scanToCartesian(scan, startPos, endPos, startAng, endAng, ...
        beta0, gamma0);
end
