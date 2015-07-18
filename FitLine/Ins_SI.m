function [fit]=stan_fitline(x,y,varargin)
%[fit]=stan_fitline(x,y,varargin)
%
% you have to cd to the folder where the .stan model is located.

%%

data = struct('x',x,'y',y,'tdata',size(x,1),'xbar',mean(x));
!rm output-* FitLine FitLine.cpp
fit = stan('file','FitLine.stan','data',data,'verbose',false,varargin{:});
%%
print(fit);
