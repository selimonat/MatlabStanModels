function [fit]=FitLineRobust_stan(x,y,x_new,varargin)

%[fit]=stan_fitline(x,y,varargin)
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
% See also:
% FitLine.m
%%

data = struct('x',x,'y',y,'N',size(x,1),'D',size(x,2),'x_new',x_new,'N_new',size(x_new,1));
!rm output-* FitLine FitLine.cpp
fit = stan('file','FitLineRobust.stan','data',data,'verbose',true,'iter',400,varargin{:});
fit.block();
%%
print(fit);
%% plot the parameters
figure;
set(gcf,'position',[680 745 1241 660]);
subplot(2,3,1)
hist(fit.extract.beta(:,1),100)
title('Beta0');
%
subplot(2,3,2)
hist(fit.extract.beta(:,2),100)
title('Beta1');

subplot(2,3,3)
plot(fit.extract.beta(:,1),fit.extract.beta(:,2),'o')
title('Beta0 vs. Beta1');

subplot(2,3,4)
hist(fit.extract.sigma_y,100)
title('Noise Sigma');
%
subplot(2,3,5)
plot(x(:,2),y,'ro','markersize',10,'markerfacecolor','r');
hold on
plot(x_new(:,2),prctile(fit.extract.y_new,[2.5 97.5])','k');

%plot the upper and lower 5% confidence intervals based on the average parameters
%of the model.
%TO DO:
% this is not yet implemented because I don't know how to inverse t
% for different sigmas.
% % ci_up   = norminv(.975,x_new*mean(fit.extract.beta)',mean(fit.extract.sigma_y) );
% % ci_down = norminv(.025,x_new*mean(fit.extract.beta)',mean(fit.extract.sigma_y));
% % plot(x_new(:,2),[ci_up ci_down],'r');
title('Data and 95% Model');
%
subplot(2,3,6)
hist(fit.extract.R2,100)
title('R2');