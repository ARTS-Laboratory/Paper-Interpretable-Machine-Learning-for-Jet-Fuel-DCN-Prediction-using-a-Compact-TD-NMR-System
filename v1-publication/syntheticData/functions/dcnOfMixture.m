function dcn = dcnOfMixture(comp1,comp2,mf1,mf2)
% compute DCN of mixture of two pure components

% load pure components and needed data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\dataForFunc\ref.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\dataForFunc\params.mat

% extract data
r1 = find(ref.Name == comp1);
r2 = find(ref.Name == comp2);

% weight mole fractions
w = ref{r1,2:end-1}.*mf1 + ref{r2,2:end-1}.*mf2;

% generate weight vector
wVec = [w, w(1)*w(2), w(1)*w(3), w(1)*w(4), w(1)*w(5), w(1)*w(6), w(1)*w(7),...
        w(2)*w(3), w(2)*w(4), w(2)*w(5), w(2)*w(6), w(2)*w(7),...
        w(3)*w(4), w(3)*w(5), w(3)*w(6), w(3)*w(7),...
        w(4)*w(5),w(4)*w(6),w(4)*w(7),...
        w(5)*w(6),w(5)*w(7),...
        w(6)*w(7)]';

% regress DCN
dcn = params.vals(end) + sum(params.vals(1:end-1).*wVec);
end