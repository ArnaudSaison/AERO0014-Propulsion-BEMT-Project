function [output] = intProp(values, r)
%INTPROP integrates the input values over the radii contained in r
%   values: contains une value type per line and the columns correspond to
%   the values for each radii
%
%   r: contains the discrete radii at which values are known
%

% Initializing the output
output = zeros(size(values,1),1);

% Trapezoidal approximation
for j = 1:length(r)-1
    output = output + ((values(:,j) + values(:,j+1)) / 2 * (r(j+1) - r(j)));
end

end