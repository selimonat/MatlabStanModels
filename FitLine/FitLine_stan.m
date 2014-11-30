function [fit]=FitLine_stan(x,y,x_new,varargin)
%[fit]=FitLine_stan(x,y,x_new,varargin)
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
% Example usage:
% fit = FitLine_stan(x,y,x_new,'iter',10000);
%
% TO DO/UNDERSTAND
% 1/ Distribution of R2 looks strange with a very sharp border and there
% are negative values. This is actually discussed in 
% http://www.stat.columbia.edu/~gelman/research/published/rsquared.pdf
% The R2 values that is computed here can be also negative, which could
% arise from situations wherethe model is even worse than the null model.
% This is possible. Additionally this way of computing the R2 takes into
% account the uncertainties on the parameter estimates, thus it is an
% adjusted R2 measure.
%%

data = struct('x',x,'y',y,'N',size(x,1),'D',size(x,2),'x_new',x_new,'N_new',size(x_new,1));
!rm output-* FitLine FitLine.cpp
fit = stan('file','FitLine.stan','data',data,'verbose',true,'iter',400,varargin{:});
fit.block();
%%
print(fit);
%% plot the parameters
figure;
set(gcf,'position',[680 745 1241 660]);
subplot(2,3,1)
MakeHist('beta0',fit.extract.beta(:,1));
%
subplot(2,3,2)
MakeHist('beta0',fit.extract.beta(:,2));

subplot(2,3,3)
plot(fit.extract.beta(:,1),fit.extract.beta(:,2),'o')

subplot(2,3,4)
MakeHist('sigma_y',fit.extract.beta(:,1));
%
subplot(2,3,5)
plot(x(:,2),y,'ro','markersize',10,'markerfacecolor','r');
hold on
plot(x_new(:,2),prctile(fit.extract.y_new,[2.5 97.5])','k');
%plot the upper and lower 5% confidence intervals based on the average parameters
%of the model.
ci_up   = norminv(.975,x_new*mean(fit.extract.beta)',mean(fit.extract.sigma_y) );
ci_down = norminv(.025,x_new*mean(fit.extract.beta)',mean(fit.extract.sigma_y));
plot(x_new(:,2),[ci_up ci_down],'r')
%
subplot(2,3,6)
MakeHist('R2',fit.extract.beta(:,1));
%
function MakeHist(name,dummy)
    hist(dummy,100);
    hold on;
    [f bins] = ksdensity(dummy);
    plot(bins,f,'r','linewidth',3);
    title(sprintf('%s: mode: %.2g, mean: %.2g','bla',mode(dummy),mean(dummy)));
end
end