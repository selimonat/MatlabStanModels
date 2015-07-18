function [fit]=FitDiag_stan(y,varargin)
%Y is a matrix that is to be modelled using 


%%
t = sqrt(length(y(:)));
%diagonal matrix and its inverse
D = diag(ones(1,t));
D = [D(:) 1-D(:)];
y     = y(:);
x_new = x;
data  = struct('x',x,'y',y,'N',size(x,1),'D',size(x,2),'x_new',x_new,'N_new',size(x,1));
!rm output-* FitDiag FitDiag.cpp
fit = stan('file','FitDiag.stan','data',data,'verbose',true,'iter',400,varargin{:});
fit.block();
%%
print(fit);
%% plot the parameters
figure;
set(gcf,'position',[680 745 1241 660]);
subplot(2,3,1)
MakeHist('beta1',fit.extract.beta(:,1));
%
subplot(2,3,2)
MakeHist('beta2',fit.extract.beta(:,2));

subplot(2,3,3)
plot(fit.extract.beta(:,1),fit.extract.beta(:,2),'o')

subplot(2,3,4)
MakeHist('sigma_y',fit.extract.sigma_y(:,1));
%
subplot(2,3,5)
imagesc(reshape(y,t,t));
%
subplot(2,3,6)
MakeHist('R2',fit.extract.R2(:,1));
%
function MakeHist(name,dummy)
    [counts xcenters] = hist(dummy,100);
    bar(xcenters,counts,'hist');
    area = sum(counts) * (xcenters(2)-xcenters(1));
    hold on;
    f = ksdensity(dummy,xcenters);
    plot(xcenters,f*area,'r','linewidth',3);
    title(sprintf('%s: mode: %.2g, mean: %.2g',name,mode(dummy),mean(dummy)));
end
end