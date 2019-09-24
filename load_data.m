clear; clc; close all;

list_dir = {
    'data/authentic/**/*.JPG', ...
    'data/forgery/**/*.tif'
};

for i = 1:size(list_dir,2)
    file_dir = dir(list_dir{i});
    for j = 1:size(file_dir,1)
        folder_name = file_dir(j).folder;
        filename = file_dir(j).name;
        path_split = strsplit(folder_name, '\');
        group = path_split{5};
        disp(['Load ', group, ' image']);
        
        if (strcmp(group, 'authentic'))
            authentic_image{j} = imread(fullfile(folder_name, filename));
        elseif (strcmp(group, 'forgery'))
            forgery_image{j} = imread(fullfile(folder_name, filename));
        end
    end
end