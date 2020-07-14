% Plot da Energia do Sistema
clear
clc
[A,B,x0,sigmas] = selectExample(3,0.3);
lambda = [0.7559 1];
points = size(sigmas,1);
select = 1;
beta = 0.2;
%% LMI Result
for j=1:length(beta)
    for i=1:length(lambda)
        out = LMIChoice(A,B,beta(j),select,lambda(i));

        varphi = varphiGeneration(sigmas,beta(j));

        [output,signal,K,P{i}]=justSimulation(out,A,B,sigmas,varphi,x0);
        xk{i} = output;
        uk{i} = signal;
    end
end
%% 
for i=1:length(lambda)
    for j=1:length(xk{1}(1,:))
        aux(j) = xk{i}(:,j)'*P{i}{j}*xk{i}(:,j);
    end
    aux = aux/max(aux);
    V{i} = aux;
end
clear aux 
%%
figure
hold on
for i=1:length(lambda)
    stairs(0:1:points-1,V{i},'LineWidth',1.5)
end
grid on
xlim([0 14])
legend(num2str(lambda(1)),num2str(lambda(2)))
title('Energia do Sistema')
xlabel('Amostra (k)')
ylabel('Amplitude')

figure
hold on
for i=1:length(lambda)
    stairs(0:1:points-1,xk{i}(1,:),'LineWidth',1.5)
end
grid on
legend(num2str(lambda(1)),num2str(lambda(2)))
title('Resposta Temporal')
xlabel('Amostra (k)')
ylabel('Amplitude')


figure
hold on
for i=1:length(lambda)
    stairs(0:1:points-1,uk{i},'LineWidth',1.5)
end
grid on
legend(num2str(lambda(1)),num2str(lambda(2)))
title('Sinal de Controle')
xlabel('Amostra (k)')
ylabel('Amplitude')


