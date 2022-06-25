function [h1, h2, h3, h4, h5] = colorRangesHorizontal(T1)
% Boundaries and ranges
[TIR1, TIR2, TIR3, TIR4] = rangeBoundariesTIR();

% Colors and opacities
[   red,        opacityRed,         ...
    lightRed,   opacityLightRed,    ...
    green,      opacityGreen,       ...
    yellow,     opacityYellow,      ...
    orange,     opacityOrange,      ...
    black,      opacityBlack,       ...
    blue,       opacityBlue,        ...
    lightBlue,  opacityLightBlue]   ...
    = colorsAndOpacititesTIR(); %#ok

% Minimum and maximum blood glucose concentrations
maxG = 100;
minG =   0;

% Has user called hold on?
userHasNotCalledHoldOn = ~ishold;

% Fill the ranges
h1 = fill([T1(1) T1(end) T1(end) T1(1)], [minG, minG, TIR1, TIR1], red,      'FaceAlpha', opacityRed,        'EdgeAlpha', 0);

if(userHasNotCalledHoldOn), hold on; end

h2 = fill([T1(1) T1(end) T1(end) T1(1)], [TIR1, TIR1, TIR2, TIR2], lightRed, 'FaceAlpha', opacityLightRed,   'EdgeAlpha', 0);
h3 = fill([T1(1) T1(end) T1(end) T1(1)], [TIR2, TIR2, TIR3, TIR3], green,    'FaceAlpha', opacityGreen,      'EdgeAlpha', 0);
h4 = fill([T1(1) T1(end) T1(end) T1(1)], [TIR3, TIR3, TIR4, TIR4], yellow,   'FaceAlpha', opacityYellow,     'EdgeAlpha', 0);
h5 = fill([T1(1) T1(end) T1(end) T1(1)], [TIR4, TIR4, maxG, maxG], orange,   'FaceAlpha', opacityOrange,     'EdgeAlpha', 0);

if(userHasNotCalledHoldOn), hold off; end