function [fit]=FitCorrFull_stan(z,varargin)
%Y is a matrix that is to be modelled 


%%
z      = z(:);
t      = sqrt(length(z));%number of entries
%diagonal matrix and its inverse
[x y]  = meshgrid(linspace(0,2*pi-2*pi/8,8));%the centering is done in the .stan file.
shift  = x(1,4);
x      = x - shift;
y      = y - shift;
x      = x(:);
y      = y(:);
%
D      = Vectorize(diag(ones(1,t)));%all diagonal elements.
i      = Vectorize(x < y);%lower half.
%we dont want to have 1/ diagonal elements to enter the game. 2/ we only
%want one half of the cmat to enter into the fitting procedure. so now
%delete all the redundant entries.
x(~i)   = [];
y(~i)   = [];
z(~i)   = [];

data   = struct('x',x,'y',y,'z',z,'N',size(x,1),'y_new',y,'x_new',x,'N_new',size(x,1));
!rm output-* FitCorrFull FitCorrFull.cpp
fit = stan('file','FitCorrFull.stan','data',data,'verbose',true,'iter',400,varargin{:});
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