%function out = LMIChoice(A,B,beta,select,lambda)
function out = LMIChoice(varargin)
A = varargin{1};
B = varargin{2};
beta = varargin{3};
select = varargin{4};
if nargin == 4
    if (select == 1)
        out = lyapFilter1(A,B,beta);
    elseif (select == 2)
        out = lyapFilter2(A,B,beta);
    elseif (select == 3)
        out = lyapFilter3(A,B,beta);
    elseif (select == 4)
        out = lyapFilter4(A,B,beta);
    elseif (select == 5)
        out = pandeyLMI(A,B);
    end
elseif nargin == 5
    lambda = varargin{5};
    if (select == 1)
        out = lyapFilter1(A,B,beta,lambda);
    elseif (select == 2)
        out = lyapFilter2(A,B,beta,lambda);
    elseif (select == 3)
        out = lyapFilter3(A,B,beta,lambda);
    elseif (select == 4)
        out = lyapFilter4(A,B,beta,lambda);
    elseif (select == 5)
        out = pandeyLMI(A,B,lambda);
    end
elseif nargin > 5
    error('Error. Maximum inputs excedeed (5)');
end
