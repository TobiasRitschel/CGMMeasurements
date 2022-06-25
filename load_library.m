function load_library
%LOAD_LIBRARY Load the CGM visualization utility functions
% 
% SYNOPSIS:
%   load_library

% Let the user know that the library is loading
fprintf('Loading CGM plotting tools .. ');

% Add model routines
addpath(genpath(fullfile(pwd, 'lib')));

% Let the user know the library was successfully loaded
fprintf('Done\n');