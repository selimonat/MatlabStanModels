# Fits a line to a set of points
data {  
  
  int<lower=0> N;#n data points    
    
  vector[N] x;#x and y data
  vector[N] y;#x and y data
  vector[N] z;#data 

  int<lower=0> N_new;#data points to be predicted 
  vector[N] x_new;#x and y data
  vector[N] y_new;#x and y data

}

parameters {
  #Gaussian
  real<lower=-1,upper=1> ampG; // weights
  real<lower=0,upper=3.2> std; // weights
  #Cosine
  real<lower=-2,upper=2> ampC; // weights
  real<lower=0,upper=2> freq; // weights
  #Constant
  real<lower=-1,upper=1> beta_const; // weights
  #noise sigma
  real<lower=0> sigma_y; // noise level  

}

transformed parameters {  
}


model {
  #Gaussian
  std  ~ lognormal(0,0.5);
  ampG ~ normal(0,.35);#normally distributed within -1 1.
  #Cosine
  ampC ~ normal(0,.7);#normally distributed within -2 2, coz peak2thorough difference can be maximally 2.
  freq ~ normal(1,.1);#we want the cosinus component pretty much localize at 1 circle along the covmat if it exists at all. If not, ampC should get closer to zero.
  #Constant
  beta_const ~ normal(0,.35);
  
  for (n in 1:N){
    z[n] ~ normal(beta_const +   ampC*cos((x[n]-y[n])*freq)  + ampG*exp( -(((x[n])/std)^2 + ((y[n])/std)^2)) , sigma_y ); // likelihood  
  }

}


generated quantities {
  vector[N_new] z_new;
  vector[N_new] dev;
  
  
  # real rss; 
  # real<lower=0> totalss;
  # real R2;

# use the model params to create independent x-y pairs as prediction
  for (i in 1:N_new){
    
    z_new[i] <- normal_rng( beta_const +   ampC*cos((x[i]-y[i])*freq)  + ampG*exp( -(((x[i])/std)^2 + ((y[i])/std)^2)) , sigma_y );

    dev[i]   <- normal_log(z[i] , beta_const +   ampC*cos((x[i]-y[i])*freq)  + ampG*exp( -(((x[i])/std)^2 + ((y[i])/std)^2)) , sigma_y  ); 
  }



  # rss <- dot_self( y - amp*exp( -(x[i,1]/std)^2 + (x[i,2]/std)^2) );
  # totalss <- dot_self(y - mean(y));
  # R2 <- 1 - rss/totalss;
}

