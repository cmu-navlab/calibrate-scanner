function cloud = scanToCartesian(scan, startPos, endPos, startAng, ...
    endAng, alpha0, gamma0)
%SCAN_TO_CARTESIAN Converts the range scanner input to a point cloud in the
%                  Cartesian space.
%   Uses the scanned data and the various scanner parameters to convert it to
%   a point cloud in the 3D space.

    % Precompute values
    cosAlpha0 = cos(alpha0);
    cosGamma0 = cos(gamma0);
    sinAlpha0 = sin(alpha0);
    sinGamma0 = sin(gamma0);

    % Set conversion from servo position in quarter-microsecods to angle
    M = (endAng - startAng) / (endPos - startPos);

    cloud = zeros(3, size(scan, 2));
    idx = 1;

    % Transform ranges to 3D Cartesian space
    for q = 1:size(scan, 2)
        servoPos = scan(1, q);
        rho = scan(2, q);
        theta = scan(3, q);
        cosTheta = cos(theta);
        sinTheta = sin(theta);
        beta    = deg2rad((servoPos - startPos) * M + startAng );
        cosBeta = cos(beta);
        sinBeta = sin(beta);
        H = [cosAlpha0 * cosGamma0, -cosAlpha0 * sinGamma0;
             cosBeta * sinGamma0 + cosGamma0 * sinAlpha0 * sinBeta, ...
                 cosBeta * cosGamma0 - sinAlpha0 * sinBeta * sinGamma0;
             sinBeta * sinGamma0 - cosBeta * cosGamma0 * sinAlpha0, ...
                 cosGamma0 * sinBeta + cosBeta * sinAlpha0 * sinGamma0];

        % This is the point in sensor frame
        X = [rho * sinTheta; rho * cosTheta];
        % Convert to base frame
        cloud(:, idx) = H * X;

        idx = idx + 1;
    end
    
    % Remove extra space
    cloud(:, idx:size(cloud, 2)) = [];
end
