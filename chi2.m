function [ p, chi2stat] = chi2( x1, n1, x2, n2)
%x1 is the # of interesting observations in demographic 1
%x2 is the # of interesting observations in demographic 2
%n1 is the total # of people in that demographic
%n2 is the total # of people in that demographic

%pooled estimate of proportion
p0=(x1+x2)/(n1+n2); 

%expected counts under the null hypothesis
n1_=n1*p0; 
n2_=n2*p0; 

%chi-square test by hand
observed = [x1 n1-n1_ x2 n2-n2_]; 
expected = [n1_ n1-n1_ n2_ n2-n2_]; 
chi2stat = sum((observed-expected).^2 ./ expected); 
p = 1 - chi2cdf(chi2stat,1); 


end

