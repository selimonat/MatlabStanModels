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
	vector<lower=0>[T] sigma_amp; 				     	// noise level  
	vector<lower=0>[T] sigma_kappa; 				     	// noise level  
	vector<lower=0>[T] sigma_offset; 				     	// noise level  
	vector<lower=0>[T] sigma_damp; 				     	// noise level  
	vector<lower=0>[T] sigma_dkappa; 				     	// noise level  
	vector<lower=0>[T] sigma_doffset; 				     	// noise level  
	vector[T] doffset;
	vector[T] damp;
	vector[T] dkappa;
}

transformed parameters {
}

model {  	
	
	sigma_y       ~ cauchy(0,5);
	sigma_doffset ~ normal(0,3); 
	sigma_damp    ~ normal(0,3); 
	sigma_doffset ~ normal(0,3); 
	sigma_amp     ~ normal(0,3); 
	sigma_kappa   ~ normal(0,3); 
	sigma_offset  ~ normal(0,3); 

	damp[1]       ~ normal(0,1); 
	dkappa[1]     ~ normal(0,1); 
	doffset[1]    ~ normal(0,1);
	amp[1]	      ~ normal(0,1);
	kappa[1]      ~ normal(0,1);
	offset[1]     ~ normal(0,1); 

	for (ti in 1:T-1){

		#
		damp[ti+1] 	~ normal(damp[ti],sigma_damp);
		dkappa[ti+1] 	~ normal(dkappa[ti],sigma_dkappa);
		doffset[ti+1] 	~ normal(doffset[ti],sigma_doffset);
		#
		offset[ti+1] 	~  normal( offset[ti]  + doffset[ti] , sigma_offset);
		amp[ti+1]    	~  normal( amp[ti]     + damp[ti]    , sigma_amp);
		kappa[ti+1]  	~  lognormal(kappa[ti] + dkappa[ti]  , sigma_kappa);
		
		for (ni in 1:N){  
			y[ti+1,ni] ~ normal(  vonMises(x[ni],amp[ti+1],kappa[ti+1],offset[ti+1]) , sigma_y );
}}}

generated quantities {
  	real y_new[T,N];
	#real kappa_new;	
	for (ti in 1:T-1){						
		for (ni in 1:N){  
			y_new[ti+1,ni] <- normal_rng(  vonMises(x[ni],amp[ti],kappa[ti],offset[ti]) , sigma_y );
	}}
	#kappa_new <- lognormal_rng(0,1.5);
}

