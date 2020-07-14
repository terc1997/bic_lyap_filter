clear
clc
%% % State-Space Generation
% Filters Parameters
beta = 0.6;
alpha = 1 - beta;
% Uncertainties
thetas = [0 1];
qsis = [0.1 0.9];
s = 1;
[A,B] = pandeySS(qsis,thetas);
% [A,B,x0] = selectExampleRamos(3);
N = length(A);
%% Alpha and noise Generation
points = 60;
sigmas = parameterGeneration(A,points,true);
varphi = varphiGeneration(sigmas,beta);
figure
hold on
plot(1:1:points,sigmas(:,1));
plot(1:1:points,varphi(:,1));
grid on
xlabel('Amostras (k)');
ylabel('Amplitude');
%% Simulation and Results
% Conditions
x0 = [0.3;-0.8;0.64;-0.03];
for k=1:4
    out = LMIChoice(A,B,beta,i);
    [outputVector,signalControl]=justSimulation(out,A,B,sigmas,varphi,x0);
    figure
    hold on
    for i=1:N
        stairs(1:1:points,outputVector(i,:),'LineWidth',1.5)
    end
    grid on
    title(['Evolução dos Estados do Sistema - LMI ',num2str(k)]);
    ylabel('Amplitude');
    xlabel('Amostra (k)');
    sc{k} = signalControl;
end
figure
hold on
for i=1:k
    stairs(1:1:points,sc{i},'LineWidth',1.5);
end
ylabel('Amplitude');
xlabel('Amostra (k)');
grid on