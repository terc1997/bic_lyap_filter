function [outputVector,signalControl,out] = simulationLyapFilter(varargin)
%function [outputVector,signalControl,out] = simulationLyapFilter(select,beta,A,B,x0,sigmas,varphi,noise,lambda)
select = varargin{1};
beta = varargin{2};
A = varargin{3};
B = varargin{4};
x0 = varargin{5};
sigmas = varargin{6};
varphi = varargin{7};
noise = varargin{8};
lambda = 1;
if nargin == 9
    lambda = varargin{9};
elseif nargin > 9
    error('Error. Maximum inputs exceeded');
end

if (select == 1)
    out = lyapFilter1(A,B,beta,lambda);
elseif (select == 2)
    out = lyapFilter2(A,B,beta,lambda);
elseif (select == 3)
    out = lyapFilter3(A,B,beta,lambda);
else
    out = lyapFilter4(A,B,beta,lambda);
end
N = length(A);
xk = zeros(length(A{1}),2);
% xk(:,1) is Xk+1 and xk(:,2) is Xk
xk(:,2) = x0;
outputVector = [];
signalControl = [];
points = length(sigmas);
if out.flag >= 0
    for i=1:points % time vector
        % LPV Matrices
        Asigma = 0;
        Bsigma = 0;
        Kvarphi = 0;
        Gvarphi = 0;
        for j=1:N
            Asigma = Asigma + A{j}*sigmas(i,j);
            Bsigma = Bsigma + B{j}*sigmas(i,j);
            Kvarphi = Kvarphi + double(out.K{j})*varphi(i,j);
            Gvarphi = Gvarphi + double(out.G{j})*varphi(i,j);
        end
        Gvarphi = inv(Gvarphi)';
        if i>1
            xk(:,2) = noise(i,:)'.*xk(:,2);
        end
        xk(:,1) = (Asigma + Bsigma*Kvarphi*Gvarphi)*xk(:,2);
        signalControl = vertcat(signalControl,Kvarphi*Gvarphi*xk(:,2));
        outputVector = horzcat(outputVector,xk(:,2));
        xk(:,2) = xk(:,1);
    end
end
end