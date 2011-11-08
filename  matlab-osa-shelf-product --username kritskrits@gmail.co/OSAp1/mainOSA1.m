% initial test



% Step 1: Read the Images
% 
% Step 2: Choose Control Points in the Images
% 
% Step 3: Save the Control Point Pairs to the MATLAB Workspace
% 
% Step 4: Fine-Tune the Control Point Pair Placement (Optional)
% 
% Step 5: Specify the Type of Transformation and Infer Its Parameters
% 
% Step 6: Transform the Unregistered Image

%%
orthophoto = imread('westconcordorthophoto.png');
figure, imshow(orthophoto)
unregistered = imread('westconcordaerial.png');
figure, imshow(unregistered)

%% Step 2: Choose Control Points in the Images
cpselect(unregistered, orthophoto)

%% Step 3: Save the Control Point Pairs to the MATLAB Workspace
% 

%% Step 4: Fine-Tune the Control Point Pair Placement (Optional)
% 
%% Step 5: Specify the Type of Transformation and Infer Its Parameters
% 
%% Step 6: Transform the Unregistered Image
