function [outputVector,signalControl,K,Pk] = justSimulation(out,A,B,sigmas,varphi,x0)
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
        Kvarphi = 0;
        Gvarphi = 0;
        Pvarphi = 0;
        for j=1:N
            Asigma = Asigma + A{j}*sigmas(i,j);
            Bsigma = Bsigma + B{j}*sigmas(i,j);
            Kvarphi = Kvarphi + double(out.K{j})*varphi(i,j);
            Gvarphi = Gvarphi + double(out.G{j})*varphi(i,j);
            Pvarphi = Pvarphi + (double(out.Pk{j}))*varphi(i,j);
        end
        Pk{i} = inv(Pvarphi);
        Gvarphi = inv(Gvarphi)';
        xk(:,1) = (Asigma + Bsigma*Kvarphi*Gvarphi)*xk(:,2);
        K = vertcat(K,Kvarphi*Gvarphi);
        signalControl = vertcat(signalControl,Kvarphi*Gvarphi*xk(:,2));
        outputVector = horzcat(outputVector,xk(:,2));
        xk(:,2) = xk(:,1);
    end
end

end