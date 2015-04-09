function [ conf_int ] = CI_std( m, s, N )

z=1.96; 
upper=m+z*s/sqrt(N); 
lower=m-z*s/sqrt(N);
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);

conf_int=['(' lower '-' upper ')']; 

end

