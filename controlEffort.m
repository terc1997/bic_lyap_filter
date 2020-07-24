% Teste de esforço de controle
clear
clc
%%
[A,B,x0,sigmas] = selectExample(4);
range = 2;
points = size(sigmas,1);
beta = [0.01 0.6];
n = 2;
instable = 0;
j=1;
s=1;
numSys = 15;
disp('1 - Parameters of System Generator Loaded')
%% System Generation
for i=1:n
    A_zero{i} = zeros(n);
    B_zero{i} = zeros(n,1);
end
% System Generation
disp('2 - Start random seed')
rng(42)
disp('3 - Start Generator')
while s < numSys+1
    controlable = false;
    A = A_zero;
    B = B_zero;
    while (~controlable)
        while max(abs(eig(A{1})))<1 && max(abs(eig(A{2})))<1
            A{1} = range*rand(2);
            A{2} = range*rand(2);
        end
        B{1} = range*rand(2,1);
        B{2} = range*rand(2,1);
        controlable = rank(ctrb(A{1},B{1}))==2 && rank(ctrb(A{2},B{2}))==2;
        controlable = controlable && rank(ctrb(A{2},B{1}))==2 && rank(ctrb(A{2},B{2}))==2;
    end
    out = LMIChoice(A,B,beta(1),1);
    if out.flag > 0
        system{s} = {A,B};
        s = s + 1;
    else
        instable = instable + 1;
    end
    j = j + 1;
end
disp('4 - End of Generation')
%% Parameter Generation
points = 60;
disp('5 - Parameter Generation')
threshold = 0.7;
rng(42)
sigmas =[];
j=1;
oldSigma = 0;
while j < points+1
    sigma_1 = rand(1);
    if abs(sigma_1-oldSigma) > threshold
        if points-j > 8
            samples = randi([2 8],1,1);
        else
            samples = points - j + 1;
        end
        sigma_2 = 1 - sigma_1;
        sigma = [sigma_1 sigma_2];
        sigma = sigma.*ones(samples,2);
        sigmas = vertcat(sigmas,sigma);
        j = j + samples;
        oldSigma = sigma_1;
    end
end
plot(sigmas)
title('Parâmetros LPV')
ylabel('Amplitude')
xlabel('Amostras')
legend('\alpha_1', '\alpha_2')