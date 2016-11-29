# Fits a Gaussian curve to a set of points
functions {
	#Function to fit.
	real vonMises(real x, real amp, real kappa, real offset) {		
		real y;
		y <- amp*((exp(kappa*cos(x))-exp(-kappa))/(exp(kappa)-exp(-kappa)))+offset;
		return y;
	}	
}
data {  
	int<lower=0> N;			#n data points
	int<lower=0> T;			#t data points
	vector[N] x;			#conditions
	real y[T,N];			#data
	vector[T] t;			#time
}

parameters {    
	vector[T] offset; 							//offset of the Gaussian
	vector[T] amp; 								// amplitude of the Gaussian
	vector<lower=0,upper=400>[T] kappa;         // stardard deviation of the Gaussian
	real<lower=0> sigma_y; 				     	// noise level  
	vector<lower=0,upper=400>[T] delta_kappa;
	vector[T] delta_offset;
	vector[T] delta_amp;
	
}

transformed parameters {
	offset[1] = 1;
	amp[1]    = 1;
	kappa[1]  = 1;
}

model {  	

	sigma_y ~ cauchy(0,5);
	for (ti in 1:T-1){

		delta_kappa[ti]  ~ lognormal(0,1.5);		
		delta_offset[ti] ~ normal(0,10);
		delta_amp[ti]    ~ normal(0,10);

#		print("s = ", ti);

		offset[ti+1] =  normal( offset[ti] + delta_offset[ti],2);
		amp[ti+1] 	 =  normal( amp[ti]    + delta_amp[ti],2);
		kappa[ti+1]  =  lognormal(kappa[ti]  + delta_kappa[ti], 1.5);
		
		for (ni in 1:N){  
			y[ti+1,ni] ~ normal(  vonMises(x[ni],amp[ti+1],kappa[ti+1],offset[ti+1]) , sigma_y );
}}}
generated quantities {
  	#real y_new[T,N];
	#real kappa_new;	
	#for (ti in 1:T){						
	#	for (ni in 1:N){  
	#		y_new[ti,ni] <- normal_rng(  vonMises(x[ni],amp[ti],kappa[ti],offset[ti]) , sigma_y );
	#}}
	#kappa_new <- lognormal_rng(0,1.5);
}

