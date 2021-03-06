
%% This script runs the Ego-Object Discovery algorithm using abstract 
%   concrepts instead of real GT labels.
%
% INSTRUCTIONS:
%   - In order to make it work, the first line from the 
%       main.m file: "loadParameters;" must be commented!
%   - Wherever a parameters is NaN then the default configuration 
%       will be used.
%   - In order to know the use and format of each parameter check the
%       file "loadParameters.m".
%%%

%% Define set of changing parameters

nDatasets__ = 10; % number of datasets used (for cross-validation)
% Number of different abstract concrepts resulting from the clustering and 
% that will be introduced to the Bag of Refill.
nConcepts__ = 200;
% Number of samples used in the concrept grouping chosen randomly from all
% of them.
nSamplesUsed__ = 20000;
results_folder__ = 'Exec_ConceptDiscovery_v3';
folders__ = {'Narrative/imageSets/Estefania1_resized', 'Narrative/imageSets/Estefania2_resized', ...
        'Narrative/imageSets/Petia1_resized', 'Narrative/imageSets/Petia2_resized', ...
        'Narrative/imageSets/Mariella_resized', 'SenseCam/imageSets/Day1', 'SenseCam/imageSets/Day2', ...
        'SenseCam/imageSets/Day3', 'SenseCam/imageSets/Day4', 'SenseCam/imageSets/Day6'};
    
re_extract_features__ = true; % re-extracts the features for all the object candidates in all the sets


cd ..
%% Extract features
if(re_extract_features__)
    % Load default parameters
    loadParameters_ConceptDiscovery;
    % Load objects file
    disp('# LOADING OBJECTS FILE...');
    load([feat_path '/objects.mat']);
    disp('# EXTRACTING FEATURES for each object of each image...');
    tic %%%%%%%%%%%%%%%%%%%%%%%
    extractFeatures(objects, feature_params, path_folders, prop_res, feat_path, max_size, features_type, [0 1]);
    toc %%%%%%%%%%%%%%%%%%%%%%%
end

%% Tests Run
for i_test__ = 1:nDatasets__
    
        disp('################################################');
        disp(['##     STARTING CROSS-VALIDATION ' num2str(i_test__) '/' num2str(nDatasets__) '         ##']);
        disp('################################################');
        
        % Load default parameters
        loadParameters_ConceptDiscovery;

        results_folder = [tests_path '/ExecutionResults/' results_folder__ '_' num2str(i_test__)];
        mkdir(results_folder);
        
        % Load objects file
        load([feat_path '/objects.mat']);
        [objects, classes, ind_train, ind_test, cluster_params] = generateBagOfRefill(objects, folders__, i_test__, nConcepts__, nSamplesUsed__, classes, feature_params, feat_path, path_folders, prop_res, cluster_params);

        % Save current training/test split
        save([results_folder '/ind_train.mat'], 'ind_train');
        save([results_folder '/ind_test.mat'], 'ind_test');
        
        %%%%%% DELETE THESE LINES
        save([results_folder '/initial_objects.mat'], 'objects');
        save([results_folder '/initial_classes.mat'], 'classes');
        
        % Run test
        main;
        disp(' ');disp(' ');
end

exit;
