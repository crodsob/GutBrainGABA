%FDR-correction for multiple comparisons using function in matlab…
function p = hu_reversefdr(n,alpha)
%Usage: n = number of hypothesis tests
%Returns uncorrected p value
 
sum = 0;
for i = 1:n
    sum = sum + 1/i;
end
p = alpha/sum;

%example usage: hu_reversefdr(12,0.05)#n=12 because we have 6 contrasts (see above) and two DMN components that we are interested in. Two DMN components are IC3 and IC18

%FSL needs the p value to be subtracted from 1 to give the value that you use when thresholding. So 1-0.0161 = 0.9839

