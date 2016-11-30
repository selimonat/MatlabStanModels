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
	real<lower=0> sigma_amp; 				     	// noise level  
	real<lower=0> sigma_offset; 				     	// noise level  
	real<lower=0> sigma_kappa; 				     	// noise level  
	real c_offset;
	real c_amp;
	real c_kappa;
	real m_offset;
	real m_amp;
	real m_kappa;


	real mu_c_offset;
	real mu_c_amp;
	real mu_c_kappa;
	real mu_m_offset;
	real mu_m_amp;
	real mu_m_kappa;
	
	real<lower=0> sigma_c_offset;
	real<lower=0> sigma_c_amp;
	real<lower=0> sigma_c_kappa;
	real<lower=0> sigma_m_offset;
	real<lower=0> sigma_m_amp;
	real<lower=0> sigma_m_kappa;
}

transformed parameters {
}

model {  	
	
	sigma_y         ~cauchy(0,2); 
	sigma_amp       ~cauchy(0,2); 
	sigma_offset    ~cauchy(0,2); 
	sigma_kappa     ~cauchy(0,2); 

	mu_c_offset 	~cauchy(0,2);
	mu_c_amp 	~cauchy(0,2);
	mu_c_kappa 	~cauchy(0,1);
	mu_m_offset 	~cauchy(0,2);
	mu_m_amp 	~cauchy(0,2);
	mu_m_kappa 	~cauchy(0,1);
	
	sigma_c_offset  ~cauchy(0,2); 
	sigma_c_amp     ~cauchy(0,2); 
	sigma_c_kappa   ~cauchy(0,2); 
	sigma_m_offset  ~cauchy(0,2); 
	sigma_m_amp 	~cauchy(0,2); 
	sigma_m_kappa 	~cauchy(0,2); 
	
	c_amp	~normal(mu_c_amp   ,sigma_c_amp);
	c_offset~normal(mu_c_offset,sigma_c_offset);
	c_kappa	~normal(mu_c_kappa ,sigma_c_kappa);
	
	m_amp	~normal(mu_m_amp   ,sigma_m_amp);
	m_offset~normal(mu_m_offset,sigma_m_offset);
	m_kappa	~normal(mu_m_kappa ,sigma_m_kappa);

	for (ti in 1:T){
				
		amp[ti]     ~ normal( c_amp         + ti*m_amp    , sigma_amp   );
		offset[ti]  ~ normal( c_offset      + ti*m_offset , sigma_offset);
		kappa[ti]   ~ lognormal( c_kappa    + ti*m_kappa  , sigma_kappa );
						
		for (ni in 1:N){  
			y[ti,ni] ~ normal(  vonMises(x[ni],amp[ti],kappa[ti],offset[ti]) , sigma_y );
}
}
}

generated quantities {
  	real y_new[T,N];
	#real kappa_new;	
	for (ti in 1:T){						
		for (ni in 1:N){  
			y_new[ti,ni] <- normal_rng(  vonMises(x[ni],amp[ti],kappa[ti],offset[ti]) , sigma_y );
	}}
	#kappa_new <- lognormal_rng(0,1.5);
}

