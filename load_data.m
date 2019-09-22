clear; clc; close all;

list_dir = dir('data/syn/original/**/*.JPG');

for i = 1:size(list_dir,1)
    % create specific array
    path_split = strsplit(list_dir(i).folder, '\');
    group = path_split{end};
    switch group
        case 'apple'
            apple{i} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'apple-ball'
            apple_ball{i} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'apple-ball-cube'
            apple_ball_cube{i} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'ball'
            ball{i} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'ball-cube'
            ball_cube{i} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'cube'
            cube{i} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
    end
end