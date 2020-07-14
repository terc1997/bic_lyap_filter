% Factibility test
% Filter Parameter
beta = 0.6;
% Product Factor
F = 0.1:0.1:3;
% State Space Parameters
thetas = [0 1];
qsis = 0.50;
% Stop Parameters
check = [true,true,true,true];
stopParam = zeros(4,1);
for j=F
    [A,B] = pandeySS([-qsis qsis],thetas,j);
    for k=1:4
        % Stop condition
        if check(k) == true
            out = LMIChoice(A,B,beta,k);
        end
        if out.flag < 0 && check(k) == true
            check(k) = false;
            stopParam(k) = j;
        end
    end
end