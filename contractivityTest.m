% Contractivity test
%% State-Space and Parameter Generation
% Filter Parameter
beta = [0.1 0.4 0.6 0.9];
[A,B,x0,sigmas] = selectExample(3,0.52);
points = size(sigmas,1);
%% Contractivity-Lambda Calculation
% Number of iterations
N = 50;
% Tolerance
tol = 1e-6;
% Output and Signal Control
timeResponse = {};
signalControl = {};
lambda = zeros(length(beta),4);
stopIterator = {};
k = 1;
for j=beta
    fprintf('Iteração %d\n',k)
    for i=1:4
        % Function to calculate the LMI
        [out,lambda(k,i),stopIterator{k,i}] = LyapFilterContractivity(A,B,j,i,N);
    end
    k = k + 1;
end
% Maximum Lambda obtained
maxLambda = max(max(lambda));
%% Output and Signal Control Generation
k = 1;
for j=beta
    fprintf('Simulação %d - OK\n',k)
    varphi = varphiGeneration(sigmas,j);
    for i=1:4
        out = LMIChoice(A,B,j,i,maxLambda);
        [output,signal,K]=justSimulation(out,A,B,sigmas,varphi,x0);
        timeResponse{k,i} = output(1,:);
        signalControl{k,i} = signal;
        kTime{k,i} = K;
    end
    k = k + 1;
end
%% Simulation
% Time Response
k = 1;
figure
for j=beta
    subplot(2,2,k)
    hold on
    for i=1:4
        stairs(1:1:points,timeResponse{k,i},'LineWidth',1.5)
    end
    grid on
    title(['Evolução Temporal. \beta: ',num2str(j),', Contratividade: ',num2str(maxLambda)]);
    ylabel('Amplitude');
    xlabel('Amostra (k)');
    xlim([1 50]);
    legend('LMI 1','LMI 2','LMI 3','LMI 4');
    k = k + 1;
end
k=1;
figure
for j=beta
    % Signal Control
    subplot(2,2,k)
    hold on
    for i=1:4
        stairs(1:1:points,signalControl{k,i},'LineWidth',1.5)
    end
    grid on
    title(['Sinal de Controle do Sistema. \beta: ',num2str(j),', Contratividade: ',num2str(maxLambda)]);
    ylabel('Amplitude');
    xlabel('Amostra (k)');
    xlim([1 50]);
    legend('LMI 1','LMI 2','LMI 3','LMI 4');
    k = k + 1;
end
figure
for j=1:length(beta)
    % K over time
    subplot(2,2,j);
    for i=1:4
        hold on
        if j==3
            stairs(1:1:points,kTime{i,j}(:,1),'LineWidth',1.5)
        else
            stairs(1:1:points,kTime{i,j}(:,1),'LineWidth',1.5)
        end
        grid on
        title(['Variação do K, LMI: ',num2str(j)]);
        ylabel('Amplitude');
        xlabel('Amostra (k)');
        legend('\beta=0.1', '\beta=0.4','\beta=0.6', '\beta=0.9')
        xlim([1 50]);
    end
end

figure
hold on
stairs(1:1:points,sigmas(:,1),'LineWidth',1.5)
for j=1:length(beta)
    varphi = varphiGeneration(sigmas,beta(j));
    stairs(1:1:points,varphi(:,1),'LineWidth',1.5)
end
grid on
title('Parâmetro LPV');
legend('\sigma','\beta = 0.1','\beta = 0.4','\beta = 0.6','\beta = 0.9')
xlabel('Amostra (k)');
ylabel('Amplitude');