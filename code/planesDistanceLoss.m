function loss = planesDistanceLoss(scan, startPos, endPos, ...
    startAng, endAng, beta0_gamma0, planesSeeds, distThreshold)
%PLANES_DISTANCE_LOSS Computes the value of a loss function based on the
%                     distance of inliers from their corresponding planes.
%   The 'scan' data is mapped to the points in the cartesian space using the
%   parameters and the 'planesSeeds' points are used to segment planes in
%   the point cloud.

    % Initialize
    beta0 = beta0_gamma0(1);
    gamma0 = beta0_gamma0(2);
    
    % Map to cartesian space
    cloud = scanToCartesian(scan, startPos, endPos, startAng, endAng, ...
        beta0, gamma0);
    
    % Segment planes
    [planesPointIndices, planes] = segmentPlanes(cloud, planesSeeds, ...
        distThreshold);
    
    % Compute the loss
    nPlanes = length(planes);
    nPoints = 0;
    sumOverPlanes = 0;
    for planeI = 1:nPlanes
        nPlanePoints = length(planesPointIndices{planeI});
        nPoints = nPoints + nPlanePoints;
        sigmaDistance = 0;
        plane = planes{planeI};
        denominator = norm(plane(1:3));
        points = cloud(:, planesPointIndices{planeI});
        
        % Compute the sum over distances for each plane
        for pointI = 1:nPlanePoints
            numerator = abs(dot([points(:, pointI); 1], plane));
            distance = numerator / denominator;
            sigmaDistance = sigmaDistance + distance;
        end
        
        % Accumulate the sum of distances over planes normalized by the
        % number of points in that plane
        sumOverPlanes = sumOverPlanes + ...
            (1 / (nPlanePoints ^ 2)) * sigmaDistance;
    end
    
    loss = nPoints * sumOverPlanes;
end
