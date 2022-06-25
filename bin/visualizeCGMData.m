%% Load and visualize CGM data from free-living experiment with a healthy male
% Clear command window
clc;

% Clear all variables
clear all;

% Close all figures
close all;

% Restore default paths
restoredefaultpath;

%% Settings
% Plotting style
% 1: Plot all data
% 2: Plot a single day (with possibility to scroll)
plotStyle = 2;

% Select a day (only used if plotStyle = 2)
selectedDay = datetime('2022-04-22');

% Font size
fs = 11;

% Line width
lw = 3;

%% Formatting
% Colors
red         = [0.8500,  0.3250, 0.0980];
blue        = [0,       0.4470, 0.7410];
lightGrey   = [0.4,     0.4,    0.4   ];

% Set default font size
set(groot, 'DefaultAxesFontSize',   fs);

% Set default line widths
set(groot, 'DefaultLineLineWidth',  lw);
set(groot, 'DefaultStairLineWidth', lw);
set(groot, 'DefaultStemLineWidth',  lw);

%% Load library and utility functions
% Add library functions
run('../load_library');

% Add utility functions
addpath(genpath(fullfile(pwd, './util')));

%% Load CGM data
% Load processed CGM data
load('./out/processedCGMData');

%% Visualize CGM measurements
% Create figure
figure('Units', 'Normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);

% Select subfigure
subplot(1, 4, 1:3);

% Color ranges
colorRangesHorizontal(cgmTime);

% Keep adding plots
hold on;

% Plot activities
mealHandle = ...
    fill(mealTime,              1e2*mealIndicatorFunction,              ...
    lightGrey,   'FaceAlpha', 0.3, 'EdgeAlpha', 0);

physicalActivityHandle = ...
    fill(physicalActivityTime,  1e2*physicalActivityIndicatorFunction,  ...
    blue,       'FaceAlpha', 0.3, 'EdgeAlpha', 0);

calibrateHandle = ...
    fill(calibrateTime,         1e2*calibrateIndicatorFunction,         ...
    red,        'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Plot CGM measurements
plot(cgmTime, cgmData, '-', 'Color', blue, 'LineWidth', 2);

% Plot BGM measurements
bgmHandle = plot(bgmTime, bgmData, 'x', 'Color', red,  'LineWidth', 2);

% Don't add anymore plots
hold off;

% Axis limits
switch plotStyle
    case 1
        xlim(cgmTime([1, end]));
    case 2
        xlim(selectedDay + [days(0), days(1)]);
end
ylim([2.5, 11]); % [mmol/L]

% Axis labels
ylabel('CGM Measurements [mmol/L]');

% Disable panning for the y-axis
pan xon;

% Legend
legend([mealHandle(1), physicalActivityHandle(1), calibrateHandle(1), bgmHandle(1)], ...
    'Meal', 'Physical activity', 'Calibration', 'Fingerprick');

% Select subfigure
subplot(1, 4, 4);

% Color ranges
colorRangesHorizontal([0, 1]);

% Keep adding plots
hold on;

% Create histogram
h = histogram(cgmData, 'Normalization', 'Probability', ...
    'Orientation', 'Horizontal', ...
    'FaceColor', blue, 'FaceAlpha', 1, 'EdgeAlpha', 0.025);

% Don't add anymore plots
hold off;

% Axis limits
xlim([0, 1.05*max(h.Values)]);
ylim([2.5, 11]); % [mmol/L]

% Axis ticks
yticks([]);

% Axis tickmarks
xticklabels(1e2*str2double(xticklabels));

% Axis labels
xlabel('Percentage [%]');