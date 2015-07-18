# Fits a line to a set of points

data {  
  int<lower=0> tGroup;#total groups
  matrix[100,tGroup] x;#bin positions
  matrix[100,tGroup] y;#probabilities  
}

parameters {          
  real<lower=0>  wei_alpha; // noise level
  real<lower=0>  wei_sigma;
  real<lower=0>  wei_alpha_cluster_mean;
  real<lower=0>  wei_alpha_cluster_std;
  real<lower=0>  wei_sigma_cluster_mean;
  real<lower=0>  wei_sigma_cluster_std;
}

transformed parameters {
}

model {
  print("1+1=", 1+1);
  for (i in 1:tGroup){
    y[,i] ~ weibull( wei_alpha[i] , wei_sigma[i] ); // likelihood    
    wei_alpha[i] ~ normal(wei_alpha_cluster_mean[i],wei_alpha_cluster_std[i]);
    wei_sigma[i] ~ normal(wei_sigma_cluster_mean[i],wei_sigma_cluster_std[i]);
  }
}

generated quantities {

}