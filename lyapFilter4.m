function [out] = lyapFilter4(varargin)
A = varargin{1};
B = varargin{2};
beta = varargin{3};
lambda = 1;
if nargin == 4
    lambda = varargin{4};
elseif nargin > 4
    error('Error. Maximum inputs exceeded (4)');
end
% Filter's parameter
alfa = 1 - beta;
% Dimensions of the rolmip variables
n = size(A{1},1);
m = size(B{1},2);
% Vertex of the polytope
N = size(A,2);
% Rolmip variables
for i=1:N
    G{i} = sdpvar(n,n,'full');
    P{i} = sdpvar(n,n,'symmetric');
    K{i} = sdpvar(m,n,'full');
end
I = eye(3*n);
eps = 1e-6;
% LMI Condition
LMIs= [];
for i=1:N %varphik
    for m=1:N %sigmak
        for r=1:N %sigmak+1
            matrix = [-G{i}-G{i}' A{m}*G{i}'+B{m}*K{i} G{i};G{i}*A{m}'+K{i}'*B{m}' (1/lambda)*P{m}-G{i}-G{i}' zeros(n,n);G{i}' zeros(n,n) -P{r}];
            LMIs = LMIs + (matrix + I*eps <= 0);
        end
    end
end
% Objective Function
obj = [];
% Solution Options
options = sdpsettings('verbose',0,'warning',0,'solver','sedumi');
% Problem Solution
sol = optimize(LMIs,obj,options);
% Factiblity
fact = min(checkset(LMIs));
out.flag = fact;
if fact >= 0
    out.G = G;
    out.Pk = P;
    out.K = K;
else
    out.G = [];
    out.Pk = [];
    out.K = [];
end


