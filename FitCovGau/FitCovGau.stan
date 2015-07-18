# Fits a line to a set of points

data {  
  
  int<lower=0> N;#n data points    
  int<lower=0> D;#d regressors
  
  vector[N] x;#x and y data
  vector[N] y;#x and y data
  vector[N] z;#data 

  int<lower=0> N_new;#data points to be predicted 
  vector[N] x_new;#x and y data
  vector[N] y_new;#x and y data
}

parameters {    
  real amp; // weights
  real<lower=0,upper=20> std; // weights
  real<lower=0> sigma_y; // noise level  
}

transformed parameters {
}

model {
  for (n in 1:N)
  z[n] ~ normal(  amp*exp( -((x[n]/std)^2 + (y[n]/std)^2))  , sigma_y ); // likelihood
}

generated quantities {
  # vector[N_new] y_new;
  # real rss;
  # real<lower=0> totalss;
  # real R2;

# use the model params to create independent x-y pairs as prediction
  # for (i in 1:N_new){
  #   y_new[i] <- normal_rng( amp*exp( -(x[i,1]/std)^2 + (x[i,2]/std)^2) , sigma_y);
  # }

  # rss <- dot_self( y - amp*exp( -(x[i,1]/std)^2 + (x[i,2]/std)^2) );
  # totalss <- dot_self(y - mean(y));
  # R2 <- 1 - rss/totalss;
}