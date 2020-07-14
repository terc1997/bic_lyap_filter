% Random Test
lambda = 0.9902;
beta = 0.4;
[A,B,x0,sigmas] = selectExample(3,0.52);
points = size(sigmas,1);
select = 1;
out = LMIChoice(A,B,beta,select,lambda);
clear sigmas
N = 1000;
disp('Setup - Ok')
%%
aux = 0;
pos = 0;
for i=1:N
    sigmas{i} = parameterGeneration(A,points);
    varphi{i} = varphiGeneration(sigmas{i},beta);
    [output,signal,K, P{i}]=justSimulation(out,A,B,sigmas{i},varphi{i},x0);
    xk{i} = output;
    timeResponse{i} = output(1,:);
    signalControl{i} = signal;
    kTime{i} = K(:,1);
    amplitude = max(kTime{i}) - min(kTime{i});
    if(amplitude > aux)
       aux = amplitude;
       pos = i;
    end
end
disp('Data - Ok')
%%
figure
hold on
% N = 100;
start= 1;

for i=start:N
    stairs(0:1:points-1,timeResponse{i})
end

figure
hold on
for i=start:N
    stairs(0:1:points-1,signalControl{i})
end

figure
hold on
for i=start:N
    stairs(0:1:points-1,kTime{i})
end

for i=start:N
    for j=1:length(xk{1}(1,:))
        aux(j) = xk{i}(:,j)'*P{i}{j}*xk{i}(:,j);
    end
    aux = aux/max(aux);
    V{i} = aux;
end
clear aux 

figure
hold on
for i=start:N
    stairs(0:1:points-1,V{i},'LineWidth',1.5)
end
grid on
figure
stairs(1:1:points,kTime{pos}/max(kTime{pos})*100,'LineWidth',1.5)