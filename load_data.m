clear; clc; close all;

list_dir = dir('data/syn/original/**/*.JPG');

apple = {};
apple_ball = {};
apple_ball_cube = {};
ball = {};
ball_cube = {};
cube = {};
for i = 1:size(list_dir,1)
    % create specific array
    path_split = strsplit(list_dir(i).folder, '\');
    group = path_split{end};
    disp(['Load ', group, ' image']);
    switch group
        case 'apple'
            apple{end+1} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'apple-ball'
            apple_ball{end+1} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'apple-ball-cube'
            apple_ball_cube{end+1} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'ball'
            ball{end+1} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'ball-cube'
            ball_cube{end+1} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
        case 'cube'
            cube{end+1} = imread(fullfile(list_dir(i).folder, list_dir(i).name));
    end
end

save('image_data.mat', 'apple', 'apple_ball', 'apple_ball_cube', 'ball', ...
    'ball_cube', 'cube');