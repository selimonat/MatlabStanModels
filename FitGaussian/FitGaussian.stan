# Fits a Gaussian curve to a set of points

data {  
  int<lower=0> N;	#n data points
  int<lower=0> N_new;	#data points to be predicted 
  int<lower=0> D;	#d regressors
  vector[N] x;	#design matrix
  vector[N] y;		#data
  vector[N_new] x_new;#data to be estimated
}

parameters {    
  real offset; //offset of the Gaussian
  real amp; // amplitude of the Gaussian
  real<lower=0,upper=180> std; // stardard deviation of the Gaussian
  real<lower=0>  sigma_y; // noise level  
}

transformed parameters {
}

model {  
  for (n in 1:N)
  y[n] ~ normal(  offset+amp*exp( -((x[n]/std)^2)) , sigma_y ); // likelihood
}

generated quantities {
  vector[N_new] y_new;
  #real rss;
  #real<lower=0> totalss;
  #real R2;


   # use the model params to create independent x-y pairs as prediction
  for (i in 1:N_new){
  y_new[i] <- normal_rng(  offset+amp*exp( -((x[i]/std)^2)) , sigma_y ); // likelihood
  }
  #for (i in 1:N_new){
  #  y_new[i] <- normal_rng( x_new[i] * beta, sigma_y);
  #}
  # compute a distribution of r2 (http://www.stat.columbia.edu/~gelman/research/published/rsquared.pdf)
  #rss <- dot_self( y - x * beta );
  #totalss <- dot_self(y - mean(y));
  #R2 <- 1 - rss/totalss;
}
