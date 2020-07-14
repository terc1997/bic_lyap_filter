function [A,B] = pandeySS(varargin)
%function [A,B] = pandeySS(qsis,thetas,F)
qsis = varargin{1};
thetas = varargin{2};
if nargin < 3
    F = 1;
elseif nargin == 3 
    F = varargin{3};
else
    error('Error.Maximum inputs exceeded (3)');
end
s = 1;
for i=1:length(thetas)
    for j=1:length(qsis)
        % Parameter Combination
        A{s} = F*[0.8 -0.25 0 1;1 0 0 0;0.8*qsis(j) -0.5*qsis(j) 0.2 0.03+qsis(j);0 0 1 0];
        B{s} = [thetas(i);0;1-thetas(i);0];
        s = s+1;
    end
end
end