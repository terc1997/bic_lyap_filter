% function out = pandeyLMI(A,B,lambda)
function out = pandeyLMI(varargin)
A = varargin{1};
B = varargin{2};
lambda = 1;
if nargin == 3
    lambda = varargin{3};
elseif nargin > 3
    error('Error. Maximum inputs exceed (3)');
end
% Dimensions of the rolmip variables
n = size(A{1},1);
m = size(B{1},2);
% Vertex of the polytope
N = size(A,2);
% Rolmip variables
for i=1:N
    X{i} = sdpvar(n,n,'full');
    Q{i} = sdpvar(n,n,'symmetric');
    L{i} = sdpvar(m,n,'full');
    Y{i} = sdpvar(m,n,'full');
    Z{i} = sdpvar(m,m,'full');
end
I = eye(2*n+m);
eps = 1e-6;
LMIs = [];
for i=1:N
    for j=1:N
        Rij = B{i}*Y{j}+Y{j}'*B{i}';
        matrix = [lambda*(X{i}+X{i}'-Q{i}) X{i}'*A{i}' -L{i}';A{i}*X{i} Q{j}-Rij B{i}*Z{j}-Y{j}';-L{i} Z{j}'*B{i}'-Y{j} Z{j}+Z{j}'];
        LMIs = LMIs + (matrix + I*eps <= 0);
    end
end

obj = [];
% Solution Options
options = sdpsettings('verbose',0,'warning',0,'solver','sedumi');
% Problem Solution
sol = optimize(LMIs,obj,options);
% Factiblity
fact = min(checkset(LMIs));
out.flag = fact;
for i=1:N
    K{i} = double(L{i})/double(X{i});
end
if fact >= 0
    out.Q = Q;
    out.L = L;
    out.X = X;
    out.K = K;
else
    out.P = [];
    out.L = [];
    out.X = [];
    out.K = [];
end
