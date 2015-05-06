function writeCloudToFile(cloud, file)
%WRITE_CLOUD_TO_FILE Writes the point cloud to a file in a format suitable
%                    for visualizing with tools.

    % Store the point cloud data
    fd = fopen(file, 'w' );
    for q = 1:size(cloud, 2)
        fprintf(fd, '%.3f %.3f %.3f\n', cloud(:, q));
    end
    fclose( fd );

end

