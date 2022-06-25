function [cgmTime, cgmData] = loadAndProcessCGMMeasurements(cgmFiles)
% loadAndProcessCGMMeasurements Load CGM measurements collected with xDrip.
%
% SYNOPSIS:
%   [cgmTime, cgmData] = loadAndProcessCGMMeasurements(cgmFiles)
%
% DESCRIPTION:
% Load .csv files with measurements of the subcutaneous blood glucose
% concentration (incl. timestamps) obtained by exporting measurements from
% xDrip.
%
% REQUIRED PARAMETERS:
%   cgmFiles - list of .csv files with CGM measurements
%
% OPTIONAL PARAMETERS:
%
% RETURNS:
%   cgmTime - vector of datetime time stamps
%   cgmData - vector of CGM measurements
%
% DEPENDENCIES:
%
% See also 
% 
% REFERENCES
% https://jamorham.github.io/#xdrip-plus
% 
% CONTACT INFORMATION
%  info@diamatica.com
%  tobk@dtu.dk
% athre@dtu.dk
%  jbjo@dtu.dk
% 
% AUTHORS
% Tobias K. S. Ritschel
% Asbjørn Thode Reenberg
% John Bagterp Jørgensen

%% Conversion factors
% Convert from mmol/L to mg/dL and back
mmolL2mgdL = 18.016;
mgdL2mmolL = 1/mmolL2mgdL;

%% Load data
% Initialize
cgmTime = [];
cgmData = [];

for i = 1:numel(cgmFiles)
    % Load data file
    cgmData_i = readtable(fullfile(cgmFiles(i).folder, cgmFiles(i).name), ...
        'Delimiter', ';');
    
    % Extract time of day
    timeOfDay = cgmData_i.TIME;
    
    % Convert time of day to a duration
    timeOfDayDuration = cellfun( ...
        @(cellstr) timeofday(datetime(cellstr, 'Format', 'HH:mm')), ...
        timeOfDay);
    
    % Convert to datetime
    cgmTime_i = cgmData_i.DAY + timeOfDayDuration;

    % Append to already load data
    cgmTime = [cgmTime; cgmTime_i         ]; %#ok
    cgmData = [cgmData; cgmData_i.UDT_CGMS]; %#ok
end

%% Process data
% Identify indices of unique measurements
[~, idx] = unique(cgmTime);

% Remove redundant measurements
cgmTime = cgmTime(idx);
cgmData = cgmData(idx);

% Convert measurements from mg/dL to mmol/L
cgmData = cgmData*mgdL2mmolL;