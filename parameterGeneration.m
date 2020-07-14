%function [sigmas,varphi,noise] = parameterGeneration(A,points,beta,instavel)
function sigmas = parameterGeneration(varargin)
A = varargin{1};
points = varargin{2};
instavel = false;
if nargin == 3
    instavel = varargin{3};
elseif nargin > 3
    error('Error. Maximum inputs exceeded');
end

j = 1;
N = length(A);
sigmas =[];
while j<(points+1)
    % Random Alpha
    sigma = rand(1,N);
    sigma = sigma/sum(sigma);
    Asigma = 0;
    for k=1:N
        Asigma = Asigma + A{k}*sigma(k);
    end
    if max(abs(eig(Asigma))) > 1 && instavel == true
        if points-j > 8
            if j<20
                samples = randi([2 4],1,1);
            else
                samples = randi([2 8],1,1);
            end
        else
            samples = points - j + 1;
        end
        sigma = sigma.*ones(samples,N);
        sigmas = vertcat(sigmas,sigma);
        j = j + samples;
    elseif instavel == false
        if points-j > 8
            samples = randi([2 8],1,1);
        else
            samples = points - j + 1;
        end
        sigma = sigma.*ones(samples,N);
        sigmas = vertcat(sigmas,sigma);
        j = j + samples;
    end
end
end