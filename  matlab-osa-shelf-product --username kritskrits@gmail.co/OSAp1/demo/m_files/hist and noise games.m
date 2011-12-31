%% 
file_img1 = 'Names.jpg';
file_img2 = 'shelf_namess05.jpg';


Image1= imread(file_img1);

imwrite(Image1,'example.jpg','jpg','Quality',100);

Image2= imread(file_img2);


PSF = fspecial('gaussian',3,3);
grayImage2 = rgb2gray(Image2);
grayImage1 = rgb2gray(Image1);
pout_imadjust = imadjust(grayImage2);
pout_histeq = histeq(grayImage2);
pout_adapthisteq = adapthisteq(grayImage2);
pout1_adapthisteq = adapthisteq(grayImage2);


figure(1);
subplot(141);imshow(Image2,[ ]);title('Original');

subplot(142);imshow(pout_imadjust,[ ]);title('Reg1');

subplot(143);imshow(pout1_adapthisteq,[ ]);title('Reg1');

subplot(144);imshow(pout_adapthisteq,[ ]);title('Reg1');


imwrite(pout_adapthisteq,'exampleSh.jpg','jpg','Quality',100);

%%

PSF = fspecial('unsharp');
Blurred = imfilter(Image1,PSF,'symmetric','conv');

figure(2);
subplot(171);imshow(Image1,[ ]);



subplot(172);imshow(Blurred,[ ]);title('Blurred');
imwrite(Blurred,'example1.jpg','jpg','Quality',100);

Noisy3 = imnoise(Blurred,'poisson');

subplot(173);imshow(Noisy3,[ ]);title('Noisy');
imwrite(Noisy3,'example2.jpg','jpg','Quality',100);

V = .01;
Noisy5 = imnoise(Blurred,'speckle',V);

subplot(174);imshow(Noisy5,[ ]);title('Noisy');
imwrite(Noisy5,'example3.jpg','jpg','Quality',100);

V = .012;
Noisy7 = imnoise(Blurred,'speckle',V);

subplot(175);imshow(Noisy7,[ ]);title('Noisy');
imwrite(Noisy7,'example4.jpg','jpg','Quality',100);


%grayImage2 = rgb2gray(Image2);


subplot(1,7,6:7);imshow(Image2,[ ]);


%figure(2);imshow(Noisy,[ ]);

%subplot(1,2,1);imshow(b);
%subplot(1,2,2);imshow(a);

%%

file_img1 = 'shelf_namess05.jpg';
file_img2 = 'Names.jpg';

figure ; imshow(file_img2);


%%
se2 = strel('line',10,90);
bla = imopen(emptySpace,se2);
figure;imshow(bla);

%%
B= IIR('shelf_namess05.jpg',3,'method','linear');

%B= IIR(A,f,'Method',method)
 %linear, spline, pchip, cubic or v5cubic
 
 %%

