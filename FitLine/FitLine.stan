# Fits a line to a set of points

data {  
  int<lower=0> N;#n data points
  int<lower=0> N_new;#data points to be predicted 
  int<lower=0> D;#d regressors
  matrix[N,D] x;#design matrix
  vector[N] y;#data
  matrix[N_new,D] x_new;
}

parameters {    
  vector[D] beta; // weights
  real<lower=0>  sigma_y; // noise level
}

transformed parameters {
  
}

model {
  # beta ~ normal(0,1000)
  # sigma_y ~   
  y ~ normal(  x * beta, sigma_y ); // likelihood
}

generated quantities {
  vector[N_new] y_new;
  real<lower=0> rss;
  real<lower=0> totalss;
  real<lower=0> R2;
   # use the model params to create independent x-y pairs as prediction
  for (i in 1:N_new){
    y_new[i] <- normal_rng( x_new[i] * beta, sigma_y);
  }

  # compute a distribution of r2
  rss <- dot_self(y - x * beta);
  totalss <- dot_self(y-mean(y));
  R2 <- 1 - rss/totalss;
}









