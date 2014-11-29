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
  vector[N] ycenter;
  vector[N] xcenter;

  # Used to compute r2
  ycenter <- y - mean(y);
  xcenter <- (col(x,2) - mean(col(x,2)));
}

model {  
  y ~ normal(  x * beta, sigma_y ); // likelihood
}

generated quantities {
  vector[N_new] y_new;
  real rss;
  real<lower=0> totalss;
  real R2;


   # use the model params to create independent x-y pairs as prediction
  for (i in 1:N_new){
    y_new[i] <- normal_rng( x_new[i] * beta, sigma_y);
  }
  # compute a distribution of r2 (http://www.stat.columbia.edu/~gelman/research/published/rsquared.pdf)
  rss <- dot_self( ycenter - xcenter*beta[2] );
  totalss <- dot_self(ycenter);
  #
  R2 <- 1 - rss/totalss;
}