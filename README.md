# 3D Scanner calibration
The goal of this project is to provide tools to assist in the calibration of a 3D scanner. The algorithms are based on the paper titled "Boresight Calibration of Construction Misalignments for 3D Scanners Built with a 2D Laser Rangefinder Rotating on Its Optical Center". Please read the paper for a description of the problem statement and the solution.

## Sample

The following is a list of sample steps that can be used to calibrate a scanner. The steps use data from **sample/data.txt** that was collected by taking readings using a hokuyo scanner from inside a closed room.

1. Open matlab and add the **code** directory to its path.
2. Run the following command to read the data.

        >> scan = readScan('../sample/data.txt', -135, 0.25, 135);
3. Run the following command to map the readings to points in a 3D Cartesian space (without calibrating yet).

        >> cloud = scanToCartesian(scan, 4000, 8000, -50, 50, 0, 0);
4. Save the cloud to a file in a format suitable for visualization using the following command.

        >> writeCloudToFile(cloud, 'cloud.txt');
5. Use a tool like [CloudCompare](http://www.danielgm.net/cc/) to manually select seed points for planes from **cloud.txt** generated in the previous step. For the sample data, you can simply use the below.

        planesSeeds = [348411, 361366; 371243, 386116; 206511, 301356];
6. The planes can be segmented from the point cloud using the planes seed points. To visualize the segmented planes, use the following commands. This step is not required for performing calibration.

        >> [planesPointIndices, ~] = segmentPlanes(cloud, planesSeeds, 0.03);
        >> plane1 = cloud(:, planesPointIndices{1});
        >> writeCloudToFile(plane1, 'plane1.txt');
        >> plane2 = cloud(:, planesPointIndices{2});
        >> writeCloudToFile(plane2, 'plane2.txt');
7. Calibrate the scanner using the following command. It also regenerates the point cloud using the calibrated scanner parameters.

        >> [postCalibrationCloud, beta0, gamma0] = calibrate(scan, 4000, 8000, -50, 50, planesSeeds, 0.03);
8. Save the regenerated point cloud for visualization.

        >> writeCloudToFile(postCalibrationCloud, 'calibrated_cloud.txt');
