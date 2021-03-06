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
%DOF
Size_X=size(X)
DOF=Size_X(1)-Size_X(2);
%%
%Contrast Vector
C=[-1.000 +1.000 0.000 0.000 0.000 0.000 0.000 0.000];
J=1;% Number of rows in the contrast vector

%%
%Store the Outputs in one variable
for i=1:NumSubj
    
    
end

%%
%Determine Beta
for i=2:NumLabel
    for j=1:NumDepth
        for k=1:NumSubj
            if k==9 || k==15
                y_lh(k)=0;
                y_rh(k)=0;
                
            else
                y_lh(k)=Output.Subj(k).LabelMean(i).lh.Depth(j);
                y_rh(k)=Output.Subj(k).LabelMean(i).rh.Depth(j);
            end
        end
        
        try
        %remove subject 9 and 15
        y_lh(y_lh==0) = [];
        y_lh=y_lh'; %Transpose y to be a column vector
        y_rh(y_rh==0)=[];
        y_rh=y_rh'; %Transpose y to be a column vector

        
        %.....................Stats Calculation......................
        Beta_lh=inv(X'*X)*X'*y_lh;
        Beta_rh=inv(X'*X)*X'*y_rh;
        
        y_hat_lh=X*Beta_lh;
        y_hat_rh=X*Beta_rh;
        
        eres_lh=y_lh-y_hat_lh;
        rvar_lh=(rssq(eres_lh)^2)/DOF;
        
        eres_rh=y_rh-y_hat_rh;
        rvar_rh=(rssq(eres_rh)^2)/DOF;
        
        G_lh=C*Beta_lh;
        G_rh=C*Beta_rh;
        
        F_lh=G_lh'*inv(C*inv(X'*X)*C')*G_lh/(J*rvar_lh);
        F_rh=G_rh'*inv(C*inv(X'*X)*C')*G_rh/(J*rvar_rh);
        
        Output.Fcalc.Label(i).lh.Depth(j)=F_lh;
        Output.Fcalc.Label(i).rh.Depth(j)=F_lh;

        end
        
    end
end
    

