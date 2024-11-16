function featureVectors = extractFeatures(X, segmentSize, increment)

% Number of segments that make up the longest feature vector
longestVectorLength = (30000 - segmentSize) / increment + 1;

% Number of features per segment, discount ARCs
nFeatures = 4;

% Number of channels
nChannels = 5;

% VAR order
arOrder = 2;

featureVectors = [];

S = length(X);

for i = 1:S

    nIncrements = (size(X{i}, 1) - segmentSize) / increment + 1;

    featureVector = zeros(1, longestVectorLength * (nFeatures * nChannels + arOrder * nChannels));

    for j = 1:nIncrements

        window = X{i}((j - 1) * increment + 1: (j - 1) * increment + segmentSize, :);

        mav = mean(abs(window), 1);

        wrms = rms(window);

        crossingsArray = window(2:end, :) .* window(1:end-1, :) < 10^(-6);
        zc = zeros(1, 5);
        for k = 1:5
            zc(1, k) = nnz(crossingsArray(:, k)) / (segmentSize - 1);
        end

        diffsArray = window(2:end, :) - window(1:end-1, :);
        scc = zeros(1, 5);
        for k = 1:5
            scc(1, k) = nnz(diffsArray(2:end, k) .* diffsArray(1:end-1, k) < 0) / (segmentSize - 2);
        end

        wl = sum(abs(diffsArray), 1) ./ sum(abs(diffsArray), "all");

        wmean = mean(window);
        stdev = std(window);
        kt = mean(((window - wmean) ./ stdev) .^ 4, 1);

        % Vector AR Model
        %varm(1, arOrder);
        arc = zeros(1, nChannels*arOrder);
        for k = 1:5
            %estMdl = estimate(arMdl, window(:, k));
            a = arburg(window(:, k), arOrder);
            % First coefficient is always 1; ignore it
            a = a(2:end);
            iStart = (k-1) * arOrder + 1;
            iEnd = k * arOrder;
            arc(1, iStart:iEnd) = a;
        end
        %arc = reshape(arc, [1, arOrder * nChannels]);

        iStart = (j - 1) * (nFeatures * nChannels + arOrder * nChannels) + 1;
        iEnd = j * (nFeatures * nChannels + arOrder * nChannels);
        featureVector(1, iStart : iEnd) = cat(2, wrms, scc, wl, kt, arc);

    end

    featureVectors = [featureVectors; featureVector];

end

end