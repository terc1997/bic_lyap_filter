% LPV Simulation Feedback
function [outputVector,signalControl,K] = LPVSimulation(out,A,B,sigmas,x0)
N = length(A);
xk = zeros(length(A{1}),2);
% xk(:,1) is Xk+1 and xk(:,2) is Xk
xk(:,2) = x0;
outputVector = [];
signalControl = [];
K=[];
points = length(sigmas);
if out.flag >= 0
    for i=1:points % time vector
        % LPV Matrices
        Asigma = 0;
        Bsigma = 0;
        Ksigma = 0;
        for j=1:N
            Asigma = Asigma + A{j}*sigmas(i,j);
            Bsigma = Bsigma + B{j}*sigmas(i,j);
            Ksigma = Ksigma + out.K{j}*sigmas(i,j);
        end
        xk(:,1) = (Asigma + Bsigma*Ksigma)*xk(:,2);
        K = vertcat(K,Ksigma);
        signalControl = vertcat(signalControl,Ksigma*xk(:,2));
        outputVector = horzcat(outputVector,xk(:,2));
        xk(:,2) = xk(:,1);
    end
end
end