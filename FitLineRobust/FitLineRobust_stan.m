function [fit]=FitLineRobust_stan(x,y,x_new,varargin)

%[[fit]=FitLineRobust_stan(x,y,x_new,varargin)
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
% fit = FitLineRobust_stan(x,y,x_new,'iter',10000);
%
% See also:
% FitLine.m
%
% Notes:
% DOF (nu) in the student_t diverges to +Inf when kept as a variable.
% Because when outliers are observed the model believes that the noise
% (sigma_y) is high. As such the model is underdetermined. Many examples
% in the Stan group keep the DOF constant.
% Kruschke p. 353 discusses a way of setting a prior expressing our
% believes on how much we think there are outliers in the data.


%%

data = struct('x',x,'y',y,'N',size(x,1),'D',size(x,2),'x_new',x_new,'N_new',size(x_new,1));
!rm output-* FitLineRobust FitLineRobust.cpp
param0 = struct('dof',5,'beta',x\y,'sigma_y',std(y),'udf',0.5);
fit = stan('file','FitLineRobust.stan','data',data,'verbose',true,'iter',400,varargin{:},'init',param0);
fit.block();
%%
print(fit);
%% plot the parameters
figure;
set(gcf,'position',[680 745 1241 660]);
subplot(2,3,1);
MakeHist('beta0',fit.extract.beta(:,1));
%%
subplot(2,3,2);
MakeHist('beta1',fit.extract.beta(:,2));
%%
subplot(2,3,3)
plot(fit.extract.beta(:,1),fit.extract.beta(:,2),'o')
title('Beta0 vs. Beta1');
%%
subplot(2,3,4)
MakeHist('sigma_y',fit.extract.sigma_y);
%% data and model
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

%%
subplot(2,3,6)
MakeHist('R2',fit.extract.R2);

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
