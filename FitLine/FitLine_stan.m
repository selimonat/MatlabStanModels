function [fit]=FitLine_stan(x,y,x_new,varargin)
%[fit]=stan_fitline(x,y,varargin)
%
% you have to cd to the folder where the .stan model is located.
% Y = X*[beta0 beta2]
%%

data = struct('x',x,'y',y,'N',size(x,1),'D',size(x,2),'x_new',x_new,'N_new',size(x_new,1));
!rm output-* FitLine FitLine.cpp
fit = stan('file','FitLine.stan','data',data,'verbose',true,'iter',400,varargin{:});
fit.block();
%%
print(fit);
% % %% plot the parameters
% % figure;
% % set(gcf,'position',[680 745 1241 660]);
% % subplot(2,3,1)
% % hist(fit.extract.beta(:,1),100)
% % title('Beta0');
% % %
% % subplot(2,3,2)
% % hist(fit.extract.beta(:,2),100)
% % title('Beta1');
% % 
% % subplot(2,3,3)
% % plot(fit.extract.beta(:,1),fit.extract.beta(:,2),'o')
% % title('Beta0 vs. Beta1');
% % 
% % subplot(2,3,4)
% % hist(fit.extract.sigma_y,100)
% % title('Noise Sigma');
% % %
% % subplot(2,3,5)
% % plot(x(:,2),y,'ko')
% % hold on
% % plot(x_new(:,2),prctile(fit.extract.y_new,[2.5 97.5])','k')
% % title('Data and 95% Model');
% % %
% % subplot(2,3,6)
% % hist(fit.extract.R2,100)
% % title('R2');