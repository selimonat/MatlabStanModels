function [fit]=FitWeibull_stan(data,varargin)
%%
data.tGroup  = size(data.x,2);
!rm output-* FitLine FitLine.cpp
fit = stan('file','FitWeibul.stan','data',data,'verbose',true,'iter',400);

% fit.block();
% %%
% print(fit);
% %% plot the parameters
% figure;
% set(gcf,'position',[680 745 1241 660]);
% subplot(2,3,1)
% MakeHist('beta0',fit.extract.beta(:,1));
% %
% subplot(2,3,2)
% MakeHist('beta0',fit.extract.beta(:,2));
% 
% subplot(2,3,3)
% plot(fit.extract.beta(:,1),fit.extract.beta(:,2),'o')
% 
% subplot(2,3,4)
% MakeHist('sigma_y',fit.extract.beta(:,1));
% %
% subplot(2,3,5)
% plot(x(:,2),y,'ro','markersize',10,'markerfacecolor','r');
% hold on
% plot(x_new(:,2),prctile(fit.extract.y_new,[2.5 97.5])','k');
% %plot the upper and lower 5% confidence intervals based on the average parameters
% %of the model.
% ci_up   = norminv(.975,x_new*mean(fit.extract.beta)',mean(fit.extract.sigma_y) );
% ci_down = norminv(.025,x_new*mean(fit.extract.beta)',mean(fit.extract.sigma_y));
% plot(x_new(:,2),[ci_up ci_down],'r')
% %
% subplot(2,3,6)
% MakeHist('R2',fit.extract.R2(:,1));
% %
% function MakeHist(name,dummy)
%     [counts xcenters] = hist(dummy,100);
%     bar(xcenters,counts,'hist');
%     area = sum(counts) * (xcenters(2)-xcenters(1));
%     hold on;
%     f = ksdensity(dummy,xcenters);
%     plot(xcenters,f*area,'r','linewidth',3);
%     title(sprintf('%s: mode: %.2g, mean: %.2g',name,mode(dummy),mean(dummy)));
% end
% end