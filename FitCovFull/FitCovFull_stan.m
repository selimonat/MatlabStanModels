function [fit]=FitCovFull_stan(z,varargin)
%Y is a matrix that is to be modelled 


%%
t     = sqrt(length(z(:)));
%diagonal matrix and its inverse
[X Y] = meshgrid(linspace(0,2*pi-2*pi/8,8));
x     = X(:);
y     = Y(:);
%
Xdiag = diag(ones(1,t));
Xdiag = [Xdiag(:) 1-Xdiag(:)];
%
z     = z(:);
data  = struct('xdiag',Xdiag(:,1),'xconst',Xdiag(:,2),'x',x,'y',y,'z',z,'N',size(x,1),'y_new',y,'x_new',x,'N_new',size(x,1));
!rm output-* FitCovFull FitCovFull.cpp
fit = stan('file','FitCovFull.stan','data',data,'verbose',true,'iter',400,varargin{:});
fit.block();
%%
print(fit);
%% plot the parameters
% figure;
% set(gcf,'position',[680 745 1241 660]);
% subplot(2,3,1)
% MakeHist('amp',fit.extract.amp(:,1));
% %
% subplot(2,3,2)
% MakeHist('std',fit.extract.std(:,1));
% 
% subplot(2,3,3)
% plot(fit.extract.std,fit.extract.amp,'o')
% 
% subplot(2,3,4)
% MakeHist('sigma_y',fit.extract.sigma_y(:,1));
% %
% subplot(2,3,5)
% imagesc([reshape(y,8,8) reshape([mean(fit.extract.y_new)],t,t)]);
%
% subplot(2,3,6)
% MakeHist('R2',fit.extract.R2(:,1));
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