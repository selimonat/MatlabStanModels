# Fits a circular Gaussian (vonMises) curve to data organized hierarchically i.e. M groups with each T data points
# to be fitted.

functions {
	#Function to fit to dependent variables. This is a vonMises function scaled to span [0 1],
	#centered on 0 degree.
	#amp is the difference between peak and thorough
	#offset is the height of the minimum value.
	#kappa is the precision parameter.
	#no free parameter for the location of the peak, it is always at 0 degrees.
	real vonMises(real x, real amp, real kappa, real offset) {		
		#how to vectorize this?, cos does only take real values not real[].
		real y;
		y <- amp*((exp(kappa*cos(x))-exp(-kappa))/(exp(kappa)-exp(-kappa)))+offset;
		return y;
	}	
}
data {  
	#the data consists of T columns of X data points, which are to be modelled using the vM function
	#Columns originates M different groups and within each group there T profiles.
	#Each participant is present in each group:
	#Nth profile in each group comes from the same participant, but this is ignored here. 

	int<lower=0> 			 X;	             #number of independent variables.
	vector[X]   			 x;	             #independent variables in degrees.
	int<lower=0> 			 T;	             #total number of profiles.
	real         			 y[X,T];	     #dependent variable, each column is one vMises profile.
	int<lower=0> 			 M;	  	         #number of groups.
	int    	     			 m[T]; 		     #indicator variable for origin of y (specifies the recording modality).
}

parameters {    
	#group-level parameters:
	real<lower=0> 	 		 sigma_y[M];     #noise variance for each group
	real	 		 		 mu_amp[M];	     #average amplitude for the group
	real	 		 		 mu_offset[M];   #average offset for the group
	real<lower=0,upper=400>  mu_kappa[M];    #average precision for the group
	real<lower=0>	 		 sigma_amp[M];   #variance for amplitude for group
	real<lower=0> 	 		 sigma_offset[M];#variance for offset for the group
	real<lower=0>   		 sigma_kappa[M]; #variance for kappa
	#profile level parameters
	real 	 		 		 amp[T];		 #amplitude for single profiles 
	real 	 		 		 offset[T];	     #offset    for single profiles
	real<lower=0,upper=400>  kappa[T];	 	 #precision for single profiles

}
transformed parameters {
}

model { 
		
		#group level (does this need to be inside the for loop?)	
		sigma_kappa   ~ cauchy(0,1);
		sigma_amp     ~ cauchy(0,1);
		sigma_offset  ~ cauchy(0,1);
		sigma_y 	  ~ cauchy(0,10);	
		
		mu_kappa      ~ lognormal(0,1.5);
		mu_amp        ~ cauchy(0,10);
		mu_offset     ~ cauchy(0,10);
		
		for (i in 1:T) {#run over profiles	
			#parameters of single profile are distributed according to group-level parameters.
			#could this be vectorized?
			offset[i] 	        ~ normal(mu_offset[m[i]]         , sigma_offset[m[i]]);
			kappa[i]     	    ~ lognormal( log(mu_kappa[m[i]]) , sigma_kappa[m[i]]);
			amp[i]    	        ~ normal(mu_amp[m[i]]            , sigma_amp[m[i]]);
	
			for (xi in 1:X){#run over the dependent variable  		
				y[xi,i] ~ normal(  vonMises(x[xi],amp[i],kappa[i],offset[i]) , sigma_y[m[i]] );	
	}}}

generated quantities {
  	#real y_new[X,T];
	#vector[T]  kappa_new;	 	  #average amplitude 
	
	#for (i in 1:T){						
	#	for (xi in 1:X){  
	#		y_new[xi,i] <- normal_rng(  vonMises(x[xi],amp[i],kappa[i],offset[i]) , sigma_y[m[i]] );
	#}}
	#for (xi in 1:X)
	#{
	#kappa_new[xi]  <- mu_kappa[m[xi]];
	#}

}

