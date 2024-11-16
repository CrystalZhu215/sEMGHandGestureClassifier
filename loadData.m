function [X, Y] = loadData(filename)
data = readmatrix(filename);

iLabel = 7;
iTrial = 10;

trials = unique(data(:, iTrial));
T = length(trials);

X = cell(T, 1);
Y = zeros(T, 1);

for i = 1:T
    % Get channels 1:5
    sample = data(data(:, iTrial) == trials(i), :);
    X(i) = {sample(:, 1:5)};
    Y(i) = mode(sample(:, iLabel));
end

end