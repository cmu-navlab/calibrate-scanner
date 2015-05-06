function [planesPointIndices, planes] = segmentPlanes(cloud, planesSeeds, ...
    distThreshold)
%SEGMENT_PLANES Uses the plane seed points to expand and identify other
%               points belonging to each plane.
%   Uses the plane seed points to identify other inliers in the cloud that
%   belong to the planes. An inlier is a point that is at a distance of
%   atmost 'distThreshold' from the plane. The 'planesSeeds' argument is
%   expected to be a 3 x P matrix where P is the number of planes. The rows
%   of this matrix are indices into the cloud.

    % Initialize
    nPlanes = size(planesSeeds, 2);
    planesPointIndices = cell(1, nPlanes);
    planes = cell(1, nPlanes);
    
    % Segment the planes
    for planeI = 1:nPlanes
        planeSeedPoints = cloud(:, planesSeeds(:, planeI));
        
        % Use the seed points to compute the plane equation
        normal = cross(planeSeedPoints(:, 1) - planeSeedPoints(:, 2), ...
            planeSeedPoints(:, 1) - planeSeedPoints(:, 3));
        d = -dot(planeSeedPoints(:, 1), normal);
        plane = [normal; d];
        planes{planeI} = plane;
        
        % Collect inliers (points within threshold distance from plane)
        inlierIndices = zeros(1, size(cloud, 2));
        idx = 1;
        denominator = norm(plane(1:3));
        for pointI = 1:size(cloud, 2)
            numerator = abs(dot([cloud(:, pointI); 1], plane));
            distance = numerator / denominator;
            if distance <= distThreshold
                inlierIndices(idx) = pointI;
                idx = idx + 1;
            end
        end
        inlierIndices(idx:length(inlierIndices)) = [];
        
        planesPointIndices{planeI} = inlierIndices;
    end

end
