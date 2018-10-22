function [resVectorDirection, magnitudeNormal, actualNormal] = estSurfNorm(newImg)
%ESTSURFNORM Function for estimate surface normal from Image
%   Suppose image projected as Lambertian Surface. Assumed that z-component
%   of vector Normal is zero. Then, we can calculate normal surface of
%   image using neighborhood method.

% Define empty array
resVectorDirection = [];
magnitudeNormal = [];
actualNormal = [];
for i = 2:size(newImg, 1) - 1
    for j = 2:size(newImg, 2) - 1
        
        % Obtain value from 8-neighborhood matrix
        imgNeighborhood(1) = newImg(i-1,j-1);
        imgNeighborhood(2) = newImg(i-1,j);
        imgNeighborhood(3) = newImg(i-1,j+1);
        imgNeighborhood(4) = newImg(i,j-1);
        imgNeighborhood(5) = newImg(i,j+1);
        imgNeighborhood(6) = newImg(i+1,j-1);
        imgNeighborhood(7) = newImg(i+1,j);
        imgNeighborhood(8) = newImg(i+1,j+1);
        
        % Perform sort operation for array
        [value, index] = sort(imgNeighborhood, 'descend');
        % Obtain total largest value in array
        totalLargestValue = sum(ismember(imgNeighborhood, value(1)));
        % Obtain all largest value in array
        largestValue = value(1:totalLargestValue);
        % Obtain all index largest value in array
        indexLargestValue = index(1:totalLargestValue);
        
        % Check if there are multiple value from 8-neighborhood matrix
        if (totalLargestValue > 1)
            for k = 1:totalLargestValue
                if (indexLargestValue(k) == 1)
                    multiVectorDirection(k, 1) = (i-1) - i;
                    multiVectorDirection(k, 2) = (j-1) - j;
                elseif (indexLargestValue(k) == 2)
                    multiVectorDirection(k, 1) = (i-1) - i;
                    multiVectorDirection(k, 2) = j - j;
                elseif (indexLargestValue(k) == 3)
                    multiVectorDirection(k, 1) = (i-1) - i;
                    multiVectorDirection(k, 2) = (j+1) - j;
                elseif (indexLargestValue(k) == 4)
                    multiVectorDirection(k, 1) = i - i;
                    multiVectorDirection(k, 2) = (j-1) - j;
                elseif (indexLargestValue(k) == 5)
                    multiVectorDirection(k, 1) = i - i;
                    multiVectorDirection(k, 2) = (j+1) - j;
                elseif (indexLargestValue(k) == 6)
                    multiVectorDirection(k, 1) = (i+1) - i;
                    multiVectorDirection(k, 2) = (j-1) - j;
                elseif (indexLargestValue(k) == 7)
                    multiVectorDirection(k, 1) = (i+1) - i;
                    multiVectorDirection(k, 2) = j - j;
                elseif (indexLargestValue(k) == 8)
                    multiVectorDirection(k, 1) = (i+1) - i;
                    multiVectorDirection(k, 2) = (j+1) - j;
                end
            end
            % Calculate suface normal direction and magnitude for multiple
            % direction
            tempVectorDirection = sum(multiVectorDirection, 1);
            resVectorDirection = [resVectorDirection; tempVectorDirection];
            actualNormal = [actualNormal; i j tempVectorDirection(1)+i tempVectorDirection(2)+j];
            magnitudeNormal = [magnitudeNormal; largestValue(1)];
        elseif (totalLargestValue == 1)
            if (indexLargestValue == 1)
                singleVectorDirection(1) = (i-1) - i;
                singleVectorDirection(2) = (j-1) - j;
            elseif (indexLargestValue == 2)
                singleVectorDirection(1) = (i-1) - i;
                singleVectorDirection(2) = j - j;
            elseif (indexLargestValue == 3)
                singleVectorDirection(1) = (i-1) - i;
                singleVectorDirection(2) = (j+1) - j;
            elseif (indexLargestValue == 4)
                singleVectorDirection(1) = i - i;
                singleVectorDirection(2) = (j-1) - j;
            elseif (indexLargestValue == 5)
                singleVectorDirection(1) = i - i;
                singleVectorDirection(2) = (j+1) - j;
            elseif (indexLargestValue == 6)
                singleVectorDirection(1) = (i+1) - i;
                singleVectorDirection(2) = (j-1) - j;
            elseif (indexLargestValue == 7)
                singleVectorDirection(1) = (i+1) - i;
                singleVectorDirection(2) = j - j;
            elseif (indexLargestValue == 8)
                singleVectorDirection(1) = (i+1) - i;
                singleVectorDirection(2) = (j+1) - j;
            end
            % If surface direction is only one direction, then assign it to
            % actual surface normal and magnitude
            resVectorDirection = [resVectorDirection; singleVectorDirection];
            actualNormal = [actualNormal; i j singleVectorDirection(1)+i singleVectorDirection(2)+j];
            magnitudeNormal = [magnitudeNormal; largestValue];
        end
    end
end

end

