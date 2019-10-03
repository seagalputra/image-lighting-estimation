% Image class contains blueprint to instantiate object to process image
% data with input
classdef ImageSegmentation
    properties
        image
        numCluster
        numReplicates
        sizeThreshold
    end
    
    properties (Access = private)
        nRows
        nCols
    end
    
    methods
        function obj = ImageSegmentation(image, numCluster, numReplicates, sizeThreshold)
            obj.image = image;
            obj.numCluster = numCluster;
            obj.numReplicates = numReplicates;
            obj.sizeThreshold = sizeThreshold;
            % Define row and column of image
            obj.nRows = size(image,1);
            obj.nCols = size(image,2);
        end
        
        function grayImage = convertToGray(obj)
            grayImage = rgb2gray(obj.image);
        end
        
        function mask = segmentKmeans(obj)
           % convert RGB image to Lab color space
           labImage = convertToLab(obj);
           % reshape matrix into two dimensional array
           listImage = reshapeImage(obj, labImage);
           % perform kmeans clustering
           clusterIdx = kmeans(listImage, obj.numCluster, 'distance', ...
               'sqEuclidean', 'Replicates', obj.numReplicates, ...
               'Display', 'iter');
           labeledMask = separateLabel(obj, clusterIdx);
           % find background from binary mask image
           mask = findBackground(obj, labeledMask);
        end
    end
    
    methods (Access = private)
        function labImage = convertToLab(obj)
            cForm = makecform('srgb2lab');
            labImage = applycform(obj.image, cForm);
        end
        
        function arrayImage = reshapeImage(obj, image)
            arrayImage = double(image(:,:,2:3));
            arrayImage = reshape(arrayImage,obj.nRows*obj.nCols,2);
        end
        
        function labeledMask = separateLabel(obj, clusterIdx)
            pixelLabels = reshape(clusterIdx, obj.nRows, obj.nCols);
            labeledMask = cell(1,3);
            for i = 1:obj.numCluster
                mask = zeros(obj.nRows, obj.nCols);
                mask(pixelLabels == i) = 1;
                labeledMask{i} = mask;
            end
        end
        
        function backgroundMask = findBackground(~, labeledMask)
            binaryMean = cellfun(@mean2, labeledMask);
            [~, idx] = max(binaryMean);
            initialBw = ~labeledMask{idx};
            backgroundMask = imfill(initialBw, 'holes');
        end
    end
end

