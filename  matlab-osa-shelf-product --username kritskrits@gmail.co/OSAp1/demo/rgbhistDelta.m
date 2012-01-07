function rgbhistDelta(I , I2 ,subplotHandler)
global bDebug;
%RGBHIST Histogram of RGB values.

if (size(I, 3) ~= 3)
    error('rgbhist:numberOfSamples', 'Input image must be RGB.')
end

nBins = 256;

rHist = abs(imhist(I(:,:,1), nBins)-imhist(I2(:,:,1), nBins));
gHist = abs(imhist(I(:,:,2), nBins)-imhist(I2(:,:,2), nBins));
bHist = abs(imhist(I(:,:,3), nBins)-imhist(I2(:,:,3), nBins));



subplot(subplotHandler);

h(1) = stem(1:256, rHist); hold on
h(2) = stem(1:256 + 1/3, gHist);
h(3) = stem(1:256 + 2/3, bHist);
hold off

set(h, 'marker', 'none')
set(h(1), 'color', [1 0 0])
set(h(2), 'color', [0 1 0])
set(h(3), 'color', [0 0 1])
axis tight
