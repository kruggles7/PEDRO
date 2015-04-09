function [ conf_int ] = CI_prop( N, P )

z=1.96; 
upper=(P+z*sqrt(P*(1-P)/N))*100; 
lower=(P-z*sqrt(P*(1-P)/N))*100;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);

conf_int=['(' lower '-' upper ')']; 

end

