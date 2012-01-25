%
% s = compareHists(h1,h2)
%       returns a histogram similarity in the range 0..1
%
% Compares 2 normalised histograms using the Bhattacharyya coefficient.
% Assumes that sum(h1) == sum(h2) == 1
%dims = [1,2,3]; //r,g,b
function s = HistsCorrelation(I1,I2,dims)
nBins = 256;
s=[];
for i=dims
    H1(:,i) = imhist(I1(:,:,i), nBins);
    H1(:,i) = H1(:,i)./sum(H1(:,i));
    
    H2(:,i) = imhist(I2(:,:,i), nBins);
    H2(:,i) = H2(:,i)./sum(H2(:,i));
    
    s = [s sum(sum(sum(sqrt(H1(:,i)).*sqrt(H2(:,i)))))];
end



