%% This scripts provides a way of appling a battery of tests for the
% object discovery algorithm.
%
% INSTRUCTIONS:
%   - In order to make it work, the first line from the 
%       main.m file: "loadParameters;" must be commented!
%   - Wherever a parameters is NaN then the default configuration 
%       will be used.
%   - There must always be the same number of nTests__ than values
%       on each parameter list.
%   - In order to know the use and format of each parameter check the
%       file "loadParameters.m".
%%%

%% Test execution PASCAL

%%% PASCAL Tests
nTests__ = 3;
nTimesTests__ = 5; % times that each test will be repeated

%%% Objectness
easiness_rate__ = {[2.15 1/1000 5000 100], [2.15 1/1000 5000 100], [1.85 1/1000 5000 100]};
objectness__type__ = {NaN, NaN, NaN}; % Ferrari

%%% Dataset
prop_res__ = {NaN, NaN, NaN}; % 1
volume_path__ = {NaN, NaN, NaN};
results_folder__ = {    'Exec_PASCAL_Ferrari_Grauman', ...
                        'Exec_PASCAL_Ferrari_CNN_Refill', ...
                        'Exec_PASCAL_Ferrari_ObjVSNoObj_CNN_Refill'};
folders__ = {NaN, NaN, NaN};
format__ = {NaN, NaN, NaN};
% write path without "volume_path"!
path_folders__ = {'F:/Object Discovery Data/Video Summarization Project Data Sets/PASCAL_12/VOCdevkit/VOC2012/', 'F:/Object Discovery Data/Video Summarization Project Data Sets/PASCAL_12/VOCdevkit/VOC2012/', 'F:/Object Discovery Data/Video Summarization Project Data Sets/PASCAL_12/VOCdevkit/VOC2012/'};
feat_path__ = {'D:/Video Summarization Objects/Features/Data PASCAL_12 Ferrari', 'D:/Video Summarization Objects/Features/Data PASCAL_12 Ferrari', 'D:/Video Summarization Objects/Features/Data PASCAL_12 Ferrari'};

%%% Features
features_type__ = {'original', 'cnn', 'cnn'};
feature_params__initialScenesPercentage__ = {NaN, NaN, NaN}; % 1
feature_params__initialObjectsPercentage__ = {NaN, NaN, NaN}; % 0.4
feature_params__initialObjectsClassesOut__ = {NaN, NaN, NaN}; % 0.5

%%% Optional MAIN processes
reload_objStruct__ = {NaN, NaN, NaN}; % false
reload_objectness__ = {NaN, NaN, NaN}; % false
reload_features__ = {NaN, NaN, NaN}; % false
reload_features_scenes__ = {NaN, NaN, NaN}; % false
apply_obj_vs_noobj__ = {false, false, true};
do_discovery__ = {NaN, NaN, NaN}; % true
do_final_evaluation__ = {NaN, NaN, NaN}; % false

%%% Others
has_ground_truth__ = {NaN, NaN, NaN}; % true
feature_params__usePCA__ = {false, false, false};
feature_params__minVarPCA__ = {NaN, NaN, NaN};
refill__ = {0, 0.2, 0.2}; % 0.2
objVSnoobj_params__SVMpath__ = {NaN, NaN, NaN}; % MSRC
cluster_params__similDist__ = {NaN, NaN, NaN}; % euclidean


%% List of parameters defined in this section
parameters_list__ = {'easiness_rate__', 'objectness__type__', 'prop_res__', ...
    'volume_path__', 'results_folder__', 'folders__', 'format__', 'path_folders__', ...
    'feat_path__', 'features_type__', 'feature_params__initialScenesPercentage__', ...
    'feature_params__initialObjectsPercentage__', 'feature_params__initialObjectsClassesOut__', ...
    'reload_objStruct__', 'reload_objectness__', 'reload_features__', ...
    'reload_features_scenes__', 'apply_obj_vs_noobj__', 'do_discovery__', ...
    'do_final_evaluation__', 'has_ground_truth__', ...
    'feature_params__usePCA__', 'feature_params__minVarPCA__' ...
    'refill__', 'objVSnoobj_params__SVMpath__', 'cluster_params__similDist__'};


%% Tests Run (DO NOT MODIFY THIS PART)

for i_test__ = 1:nTests__
    for j_test__ = 1:nTimesTests__
        
        disp('################################################');
        disp(['##     STARTING TEST BATTERY ' num2str(i_test__) '/' num2str(nTests__) ' - ' num2str(j_test__) '/' num2str(nTimesTests__) '        ##']);
        disp('################################################');
        
        % Load default parameters
        loadParameters_PASCAL_tests;

        % Change test-dependent parameters
        for param__ = parameters_list__

            % Format battery parameter name
            param_this__ = param__{1};

            % Format original parameter name
            param__ = param__{1}(1:end-2);
            param__ = regexp(param__, '__', 'split');
            param_original__ = '';
            for part__ = param__
                param_original__  = [param_original__ part__{1} '.'];
            end
            param_original__ = param_original__(1:end-1);

            % Check if battery param is 'NaN'
            try
                if(~isnan(eval([param_this__ '{' num2str(i_test__) '}'])))
                    error('Not NaN: assign battery param value!');
                end
            catch
                if(strcmp(param_this__, 'path_folders__') || strcmp(param_this__, 'feat_path__'))
                    aux = 'volume_path';
                else
                    aux = '';
                end
                eval([param_original__ ' = [' aux ' ' param_this__ '{' num2str(i_test__) '}];']);
            end

        end

        % Reload dynamic parameters
        if(strcmp(objectness.type, 'Ferrari'))
            run 'Objectness Ferrari/objectness-release-v2.2/startup'
        elseif(strcmp(objectness.type, 'MCG'))
            thispath = pwd;
            cd(objectness.pathMCG)
            run install
            cd(thispath)
        end

        results_folder = [tests_path '/ExecutionResults/' results_folder '_' num2str(j_test__)];
        mkdir(results_folder);

        % Run test
        main;
        disp(' ');disp(' ');
    end
end

exit;
