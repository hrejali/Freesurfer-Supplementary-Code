%Name:Hossein Rejali
%Superviser:Dr.Ali Khan
%Date:January 11th 2017
%Title: F value Determination Based on mri_glmfit documentation in
%freesurfer

%%
%..............................Description................................
% Math is in https://surfer.nmr.mgh.harvard.edu/fswiki/mri_glmfit
% Requires output from Intersubject OverlayLabelIntersection

%%
fsHome='/home/hrejali/alik_schizmyelin/freesurfer';
cd(fsHome);
% Import Design matrix X
Xdir=['./Group_Analysis/Xg.dat'];
sizeX = [8 39];
fileID=fopen(Xdir,'r');
formatSpec='%f';
X=fscanf(fileID,formatSpec,sizeX);
X=X';
%%



%%
%Determine Beta

Beta=inv()

