function dispLog(msg, verb, pre)
% dispLog  display log
%   dispLog(msg, verb) displays a message if verb = 1
%
%   dispLog(msg, verb, pre) changes default prefix
%
%   Example
%       verbose = 1;
%       dispLog('test', verbose)
%
%       >> 'LOG:    test'

switch nargin
    case 2
        if verb == 1
            disp(['LOG:    ', msg]);
        end
    case 3
        if verb == 1
            disp([pre, msg]);
        end
end

end