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
  real<lower=0> sigma_y; // noise level
  real<lower=0,upper=1> udf;
}

transformed parameters {    
  real dof;

  # used to compute DOF
  dof <- 1-log(1-udf);# Kruschke p. 353 discusses a way of setting a prior expressing our
                      # believes on how much we think there are outliers in the data. 
                      # This maps udf ranged [0 1] to dof [1, Y] where Y depends on the scale 
                      # factor before the log term, which is here set to 1.
}

model {     
  y ~ student_t( dof, x * beta , sigma_y ); // likelihood
}

generated quantities {
  vector[N_new] y_new;

  real rss;
  real<lower=0> totalss;
  real R2;


  # use the model params to create independent x-y pairs as prediction
  for (i in 1:N_new){
    y_new[i] <- student_t_rng( dof,x_new[i] * beta, sigma_y);
  }
  # compute a distribution of r2 (http://www.stat.columbia.edu/~gelman/research/published/rsquared.pdf)
  rss <- dot_self( y - x * beta );
  totalss <- dot_self(y-mean(y));  
  R2 <- 1 - rss/totalss;
  #
}