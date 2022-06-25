%% Load and visualize CGM data from free-living experiment with a healthy male
% Clear command window
clc;

% Clear all variables
clear all;

% Close all figures
close all;

% Restore default paths
restoredefaultpath;

%% Load library and utility functions
% Add library functions
run('../load_library');

% Add utility functions
addpath(genpath(fullfile(pwd, './util')));

%% Load CGM data
% Identify CGM data files
cgmFiles = dir('../data/Ritschel2022_04_*_CGMData.csv');

% Load and process CGM measurements
[cgmTime, cgmData] = loadAndProcessCGMMeasurements(cgmFiles);

%% Load diary data
% Load diary data
diaryData = readtable('../data/Ritschel2022_04_13_CGMDiary.txt', ...
    'Delimiter', ';', 'VariableNamingRule', 'Preserve');

% Identify meals
idxMeal = cellfun( ...
    @(cellstr) ismember(lower(cellstr), {'breakfast', 'lunch', 'dinner', 'snack'}), ...
    diaryData.Activity);

% Identify physical activity
idxPhysicalActivity = cellfun( ...
    @(cellstr) ismember(lower(cellstr), {'walk', 'bike'}), ...
    diaryData.Activity);

% Identify calibrations
idxCalibrate = cellfun( ...
    @(cellstr) strcmpi(cellstr, 'calibrate'), ...
    diaryData.Activity);

% Identify blood glucose measurements (previously called self-monitoring of
% blood glucose or SMBG)
idxBGM = cellfun( ...
    @(cellstr) strcmpi(cellstr, 'fingerprick'), ...
    diaryData.Activity);

% Identify times of activities
mealTime = [
    diaryData.StartTime(idxMeal              )';
    diaryData.StartTime(idxMeal              )';
    diaryData.EndTime(  idxMeal              )';
    diaryData.EndTime(  idxMeal              )'];
physicalActivityTime = [
    diaryData.StartTime(idxPhysicalActivity  )';
    diaryData.StartTime(idxPhysicalActivity  )';
    diaryData.EndTime(  idxPhysicalActivity  )';
    diaryData.EndTime(  idxPhysicalActivity  )'];
calibrateTime = [
    diaryData.StartTime(idxCalibrate         )';
    diaryData.StartTime(idxCalibrate         )';
    diaryData.EndTime(  idxCalibrate         )';
    diaryData.EndTime(  idxCalibrate         )'];
bgmTime = diaryData.StartTime(idxBGM)'; % StartTime is identical to EndTime

% BGM measurements
bgmData = str2double(diaryData.Value(idxBGM));

% Indicator function used for plotting
indicatorFunction = @(idx) [
    zeros(1, nnz(idx));
     ones(1, nnz(idx));
     ones(1, nnz(idx));
    zeros(1, nnz(idx))];

% Indicator functions of activities
mealIndicatorFunction               = indicatorFunction(idxMeal             );
physicalActivityIndicatorFunction   = indicatorFunction(idxPhysicalActivity );
calibrateIndicatorFunction          = indicatorFunction(idxCalibrate        );

%% Save data
save('./out/processedCGMData');