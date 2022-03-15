function dataOut = coeffCleanup(dataIn, rpl)
%COEFFCLEANUP removes negative and exploding values and replaces them
%   dataIn: data to ckean up
%   rpl: optional parameter to choose what the impossible values are
%   replace with (default = 0)
%

% optional parameter
if nargin == 1
	rpl = 0;
end

% Cleanup
selected_val = (dataIn < 0 | dataIn > 1);   % finding impossible values

dataOut = dataIn .* (~selected_val);        % all selected values are set to 0
dataOut = dataOut + selected_val * rpl;     % the replacement is added where needed

end

