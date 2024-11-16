function segments = segmentData(X, Y)

S = length(X);
segments = {S, 1};

for i = 1:S
    if Y(i) <= 10
        segments{i} = abs(X{i}(6001:end, :));
    elseif Y(i) <= 13
        segments{i} = abs(X{i}(6001:16000, :));
    elseif Y(i) == 14 || Y(i) == 17
        segments{i} = abs(X{i}(6001:26000, :));
    elseif Y(i) == 15
        segments{i} = abs(X{i}(6001:36000, :));
    else
        segments{i} = abs(X{i}(10001:20000, :));
    end
    
end

end
