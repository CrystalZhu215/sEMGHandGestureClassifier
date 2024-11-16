function groupNumber = getActivityGroup(activityLabel)

if activityLabel == 0
    groupNumber = 0;
elseif ismember(activityLabel, [2, 9, 10])
    groupNumber = 1;
elseif ismember(activityLabel, [3, 4, 5, 6, 7, 8])
    groupNumber = 2;
elseif ismember(activityLabel, [11, 12, 13, 16, 18, 19, 20, 21])
    groupNumber = 3;
elseif ismember(activityLabel, [1, 17])
    groupNumber = 4;
elseif ismember(activityLabel, [14, 15])
    groupNumber = 5;
end

end