function subjectStr = getsubjectstring(subjectId)

if subjectId < 10
    subjectStr = sprintf('0%d', subjectId);
else
    subjectStr = sprintf('%d', subjectId);
end

end

function [X, Y] = extractdata(subjectId, isTrain)

subjectStr = getsubjectstring(subjectId);

if isTrain
    dataset = 'Train';
    abbreviation = 'tr';
else
    dataset = 'Test';
    abbreviation = 'tt';
end

filepath = sprintf('data/%sCSV_C23/S0%s_%s.csv', dataset, subjectStr, abbreviation);
[X, Y] = loadData(filepath);

X = preprocess(X);

X = segmentData(X, Y);

end

function accuracy = computeaccuracy(pred, truth)

accuracy = sum(pred==truth) / length(pred);

end

function precision = computeprecision(pred, truth)

precision = 0;
nPositiveClasses = 0;

for label=1:21 % cycle through classes
    pc = sum(pred == label);
    if pc == 0
        lp = 0;
    else
        lp = sum(and(truth == label, pred == label)) / pc;
        nPositiveClasses = nPositiveClasses + 1;
    end
    precision = precision + lp;
end

precision = precision / nPositiveClasses;

end

function recall = computerecall(pred, truth)

recall = 0;
for label=1:21 % cycle through classes
    lr = sum(and(truth == label, pred == label)) / sum(truth == label);
    recall = recall + lr;
end

recall = recall / 21;

end

function f1 = computef1(precision, recall)

f1 = 2 * precision * recall / (precision + recall);

end

% Train SVM

accuracies = zeros(25, 1);
windowSize = 250;
increment = 250;

subjectId = input("Subject id of dataset: ");

disp("Loading data...");

% Remove conditional if changing subjects
%if ~exist("X", "var") || ~exist("Y", "var")
[X, Y] = extractdata(subjectId, true);
%end

disp("Extracting features...");

featureVectors = extractFeatures(X, windowSize, increment);

svmParams = templateSVM('BoxConstraint', 1, 'KernelFunction', 'polynomial', 'PolynomialOrder', 3, 'KernelScale', 75, 'Standardize', true);

optimizeParams = hyperparameters('fitcecoc',featureVectors,Y,'svm');
optimizeParams(1).Optimize = false;
optimizeParams(2).Optimize = false;
optimizeParams(3).Optimize = true;
optimizeParams(4).Optimize = false;
optimizeParams(5).Optimize = false;
optimizeParams(6).Optimize = false;

hpoOptions = hyperparameterOptimizationOptions('Repartition', true, 'KFold', 10);

disp("Training model...");

Mdl = fitcecoc(featureVectors, Y, 'Learners', svmParams);

% Cross Validation

disp("Performing cross validation...")

options = statset('UseParallel',true);

cvp = cvpartition(147, "KFold", 10);

CVMdl = crossval(Mdl, 'Options', options, 'CVPartition', cvp);

CVPred = kfoldPredict(CVMdl, 'Options', options);
CVAccuracy = computeaccuracy(CVPred, Y);
disp("Cross-validation accuracy: " + CVAccuracy);

% Test SVM
disp("Testing model...");

[Xt, Yt] = extractdata(subjectId, false);

featureVectorsTest = extractFeatures(Xt, windowSize, increment);

%Mdl = CVMdl.Trained{1};
pred = predict(Mdl, featureVectorsTest);

testAccuracy = computeaccuracy(pred, Yt);
precision = computeprecision(pred, Yt);
recall = computerecall(pred, Yt);
f1 = computef1(precision, recall);

disp("Accuracy: " + testAccuracy);
disp("Precision: " + precision);
disp("Recall: " + recall);
disp("F1 Score: " + f1);