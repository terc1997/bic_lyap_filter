% Contractivity test
%% State-Space and Parameter Generation
% Filter Parameter
beta = [0.1 0.4 0.6 0.9];
qsi = 0.5:0.1:0.55;
%% Parameter Calculation
d = 1;
params = {};
for j=beta
    LMI = 1:1:4;
    for s=qsi
        [A,B,x0,sigmas] = selectExample(3,s);
        k=1;
        for i=LMI
            % Function to calculate the LMI
            out = LMIChoice(A,B,j,i);
            if out.flag >= 0
                params{d,k} = s;
            end
            k = k+1;
        end
    end
    d = d + 1;
end
%% Output and Signal Control Generation
minQsi = min(min(cell2mat(params)));
[A,B,x0,sigmas] = selectExample(3,minQsi);
points = size(sigmas,1);
k = 1;
for j=beta
    fprintf('Simulação %d - OK\n',k)
    varphi = varphiGeneration(sigmas,j);
    for i=1:4
        out = LMIChoice(A,B,j,i);
        [output,signal,K]=justSimulation(out,A,B,sigmas,varphi,x0);
        timeResponse{k,i} = output(1,:);
        signalControl{k,i} = signal;
        kTime{k,i} = K;
    end
%     i = i + 1;
%     out = LMIChoice(A,B,j,i);
%     [output,signal,K]=LPVSimulation(out,A,B,sigmas,x0);
%     timeResponse{k,i} = output(1,:);
%     signalControl{k,i} = signal;
%     kTime{k,i} = K;
k = k + 1;
end
%% Plot
k = 1;
figure
for j=beta
    subplot(2,2,k)
    hold on
    for i=1:4
        stairs(1:1:points,timeResponse{k,i},'LineWidth',1.5)
    end
    grid on
    title(['Evolução Temporal. \beta: ',num2str(j)]);
    ylabel('Amplitude');
    xlabel('Amostra (k)');
    xlim([1 32]);
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
    title(['Sinal de Controle do Sistema. \beta: ',num2str(j)]);
    ylabel('Amplitude');
    xlabel('Amostra (k)');
    xlim([1 32]);
    legend('LMI 1','LMI 2','LMI 3','LMI 4');
    k = k + 1;
end
figure
for j=1:length(beta)
    % K over time
    subplot(2,2,j);
    for i=1:4
        if j==3
            hold on
            stairs(1:1:points,kTime{i,j}(:,1),'LineWidth',1.5)
            disp(max(abs((kTime{i,j}(:,1)))))
        else
            hold on
            stairs(1:1:points,kTime{i,j}(:,1),'LineWidth',1.5)
        end
        grid on
        title(['Variação do K, LMI: ',num2str(j)]);
        ylabel('Amplitude');
        xlabel('Amostra (k)');
        legend('\beta=0.1', '\beta=0.4','\beta=0.6', '\beta=0.9')
        xlim([1 32]);
    end
end