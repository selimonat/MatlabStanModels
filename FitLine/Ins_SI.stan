
# Fits a line to a set of points

data {  
  int<lower=0> tsub;
  real x[tsub];
  real y[tsub];  
  real xbar;
}

parameters {
  real alpha;
  real beta;

  real mu_alpha;
  real mu_beta;          // beta.c in original bugs model

  real<lower=0> sigmasq_y;
  # real<lower=0> sigmasq_alpha;
  # real<lower=0> sigmasq_beta;
}

transformed parameters {
  real<lower=0> sigma_y;       // sigma in original bugs model
  # real<lower=0> sigma_alpha;
  # real<lower=0> sigma_beta;

  sigma_y <- sqrt(sigmasq_y);
  # sigma_alpha <- sqrt(sigmasq_alpha);
  # sigma_beta <- sqrt(sigmasq_beta);
}


model {
  # mu_alpha ~ normal(0, 1000);
  # mu_beta  ~ normal(0, 1000);

  sigmasq_y ~ inv_gamma(0.001, 0.001);
  # sigmasq_alpha ~ inv_gamma(0.001, 0.001);
  # sigmasq_beta ~ inv_gamma(0.001, 0.001);

  alpha ~ normal(0, 5); // vectorized  
  beta ~ normal(0, 5);  // vectorized

  for (nsub in 1:tsub)
    y[nsub] ~ normal( alpha + (x[nsub] - xbar)* beta, sigma_y );
}

generated quantities {
real alpha0;
  alpha0 <- alpha + xbar * beta;
}









