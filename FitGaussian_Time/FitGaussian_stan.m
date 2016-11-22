function [fit]=FitGaussian_stan(x,y,t,varargin)
%[fit]=FitGaussian_stan(x,y,x_new,varargin)
%
% you have to cd to the folder where the .stan model is located.
% Y = X*[beta0 beta2]
%
% X_NEW is used for predictions.
%
% VARARGIN is fed to stan.
%
% X and X_new are supposed to have a column of ones.
%

%%
if 0
    T      = 100; 
    t      = [1:T]';
    x      = [-135:45:180]';
    offset = linspace(10,10,T)';
    amp    = linspace(5,5,T)';
    sd     = linspace(50,80,T)';    
    for ti = 1:T
        y(ti,:) = [offset(ti) + amp(ti)*exp(-(x/sd(ti)).^2) + randn(8,1)*1]';
    end    
end
%%

data = struct('x',x,'y',y,'t',t,'N',size(x,1),'T',size(t,1));
!rm output-* FitGaussian FitGaussian.cpp
fit = stan('file','FitGaussian.stan','data',data,'verbose',true,'iter',400,varargin{:});
fit.block();
%%
print(fit);
%% plot the parameters
try
    figure;
    set(gcf,'position',[680 745 1241 660]);    
    imagesc(corrcoef([mean(fit.extract.offset,2) mean(fit.extract.amp,2) mean(fit.extract.std,2)]));    
    colorbar
end
%plot the upper and lower 5% confidence intervals based on the average parameters
%of the model.
%ci_up   = norminv(.975,x_new*mean(fit.extract.y_new)',mean(fit.extract.sigma_y) );
%ci_down = norminv(.025,x_new*mean(fit.extract.beta)',mean(fit.extract.sigma_y));
%plot(x_new(:,2),[ci_up ci_down],'r')
%
%subplot(2,3,6)
%MakeHist('R2',fit.extract.R2(:,1));
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