# Fits a Gaussian curve to a set of points

data {  
  int<lower=0> N;		#n data points
  int<lower=0> T;		#t data points
  vector[N] x;			#conditions
  real y[T,N];			#data
  vector[T] t;			#time
}

parameters {    
  vector[T] offset; 				//offset of the Gaussian
  vector[T] amp; 					// amplitude of the Gaussian
  vector<lower=0,upper=180>[T] std; // stardard deviation of the Gaussian
  vector<lower=0>[T]  sigma_y; 		// noise level  
}

transformed parameters {
}

model {  
  for (ti in 1:T){
  for (ni in 1:N){
  y[ti,ni] ~ normal(  offset[ti]+amp[ti]*exp( -((x[ni]/std[ti])^2)) , sigma_y[ti] );
}}
}
generated quantities {
  real y_new[T,N];
  #real rss;
  #real<lower=0> totalss;
  #real R2;


   # use the model params to create independent x-y pairs as prediction
  for (ti in 1:T){
  for (i in 1:N){
  y_new[ti,i] <- normal_rng(  offset[ti]+amp[ti]*exp( -((x[i]/std[ti])^2)) , sigma_y[ti] );
  }}
  #for (i in 1:N_new){
  #  y_new[i] <- normal_rng( x_new[i] * beta, sigma_y);
  #}
  # compute a distribution of r2 (http://www.stat.columbia.edu/~gelman/research/published/rsquared.pdf)
  #rss <- dot_self( y - x * beta );
  #totalss <- dot_self(y - mean(y));
  #R2 <- 1 - rss/totalss;
}
