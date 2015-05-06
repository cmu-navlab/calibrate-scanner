function scan = readScan(scanFile, startTheta, thetaStep, endTheta)
%READ_SCAN Reads the input scanner data into a 2 x N matrix where N is the
%          number of valid readings.

    % Load input data.
    data = importdata(scanFile);
    
    idx = 1;

    % Read into datastructure
    servoPos = data(:, 1);
    thetas = deg2rad(startTheta): deg2rad(thetaStep) : deg2rad(endTheta);
    scan = zeros(3, length(servoPos) * 1081);
    for q = 1:length(servoPos)
        for k = 1:length(thetas)
            rho = data(q, k + 1);
            % TODO : Make configurable
            if rho >= 6
                continue;
            end
            scan(:, idx) = [servoPos(q), rho, thetas(k)];

            idx = idx + 1;
        end
    end
    
    % Remove extra space
    scan(:, idx : size(scan, 2)) = [];
end
