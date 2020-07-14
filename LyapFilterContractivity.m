% Lambda contractivity
%function out = LyapFilterContractivity(A,B,beta,select,N,tol)
function [out,lambda,i] = LyapFilterContractivity(varargin)
A = varargin{1};
B = varargin{2};
beta = varargin{3};
select = varargin{4}; 
interval = [0 1]; 
% Optional parameters
N = 100; 
tol = 1e-3;
% Optional arguments
if nargin == 5
    N = varargin{5};
elseif nargin == 6
    N = varargin{5};
    tol = varargin{6};
elseif nargin > 6
    error('Error. Maximum inputs excedeed (6)');
end
i = 1;
while (i < N)
    if ((interval(2)-interval(1))/2 < tol) && out.flag >= 0
        break;
    end
    aux = (interval(1) + interval(2))/2;
    out = LMIChoice(A,B,beta,select,aux);
    if out.flag >= 0 && out.flag < 100
        interval(2) = aux;
    else
        interval(1) = aux;
    end
    i = i + 1;
end
lambda = aux;
end
