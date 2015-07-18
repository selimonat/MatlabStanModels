# Fits a line to a set of points

data {  
  
  int<lower=0> N;#n data points    
  
  vector[N] xdiag;#x and y data  
  vector[N] xconst;#x and y data
  vector[N] x;#x and y data
  vector[N] y;#x and y data
  vector[N] z;#data 

  int<lower=0> N_new;#data points to be predicted 
  vector[N] x_new;#x and y data
  vector[N] y_new;#x and y data
}

parameters {    
  real ampG; // weights
  real ampC; // weights
  real beta_diag; // weights
  real beta_const; // weights
  real<lower=0,upper=20> std; // weights
  real<lower=0,upper=2> freq; // weights
  real<lower=0> sigma_y; // noise level  
}

transformed parameters {
}

model {
  for (n in 1:N)
  z[n] ~ normal( xconst[n]*beta_const + xdiag[n]*beta_diag +  ampC*cos((x[n]-y[n])*freq)  + ampG*exp( -(((x[n]-2.3562)/std)^2 + ((y[n]-2.3562)/std)^2)), sigma_y ); // likelihood
}

generated quantities {
  vector[N_new] z_new;
  # real rss;
  # real<lower=0> totalss;
  # real R2;

# use the model params to create independent x-y pairs as prediction
  for (i in 1:N_new){
    z_new[i] <- normal_rng( xconst[i]*beta_const + xdiag[i]*beta_diag +  ampC*cos((x[i]-y[i])*freq)  + ampG*exp( -(((x[i]-2.3562)/std)^2 + ((y[i]-2.3562)/std)^2))  , sigma_y);
  }

  # rss <- dot_self( y - amp*exp( -(x[i,1]/std)^2 + (x[i,2]/std)^2) );
  # totalss <- dot_self(y - mean(y));
  # R2 <- 1 - rss/totalss;
}