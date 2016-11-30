# Fits a Gaussian curve to a set of points
functions {
	#Function to fit.
	real vonMises(real x, real amp, real kappa, real offset) {		
		real y;
		y      = amp*((exp(kappa*cos(x))-exp(-kappa))/(exp(kappa)-exp(-kappa)))+offset;
		return y;
	}	
}
data {  
	int<lower=0> N;			#n data points
	int<lower=0> T;			#t data points
	int<lower=0> S;			#t data points
	vector[N] x;			#conditions
	real y[T,N,S];			#data
}

parameters {    
	real offset[T,S]; 		//offset of the Gaussian
	real amp[T,S]; 			// amplitude of the Gaussian
	real<lower=0,upper=400> kappa[T,S];       // stardard deviation of the Gaussian
	real<lower=0> sigma_y; 		// noise level  
	real mu_amp[T,S];
	real mu_offset[T,S];
	real mu_kappa[T,S];
	real mu_mu_kappa[T];
	real mu_mu_offset[T];
	real mu_mu_amp[T];
}

transformed parameters {
}
model {  	
	sigma_y ~ cauchy(0,5);	
	for (ti in 1:T){	
		
		mu_mu_kappa[ti] ~ lognormal(0,1.5);
		mu_mu_offset[ti]~ normal(0,5);
		mu_mu_amp[ti]   ~ normal(0,5);

		for (si in 1:S) {

		mu_kappa[ti,si]  ~ lognormal(mu_mu_kappa[ti],1.5);
		mu_offset[ti,si] ~ normal(mu_mu_offset[ti] , 10);
		mu_amp[ti,si]    ~ normal(mu_mu_amp[ti]    , 10);


		kappa[ti,si]     ~ lognormal(mu_kappa[ti,si],1.5);		
		offset[ti,si]    ~ normal(mu_offset[ti,si]  ,10);
		amp[ti,si]       ~ normal(mu_amp[ti,si]     ,10);


		for (ni in 1:N){  
			y[ti,ni,si] ~ normal(  vonMises(x[ni],amp[ti,si],kappa[ti,si],offset[ti,si]) , sigma_y );
	}}}}

generated quantities {
  	#real y_new[T,N];
	real kappa_new;	
	#for (ti in 1:T){						
	#	for (ni in 1:N){  
	#		y_new[ti,ni] <- normal_rng(  vonMises(x[ni],amp[ti],kappa[ti],offset[ti]) , sigma_y );
	#}}
	kappa_new <- lognormal_rng(0,1.5);
}

