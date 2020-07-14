function varphi = varphiGeneration(sigmas,beta)
alpha = 1 - beta;
j = 1;
while j<= length(sigmas(:,1))
    if j==1
        varphi(j,:) = sigmas(j,:);
    else
        varphi(j,:) = beta*varphi(j-1,:) + alpha*sigmas(j,:);
    end
    j = j + 1;
end