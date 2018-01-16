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
Xdir=['./Group_Analysis/Xg.dat'];%specify where the design maxtrix is
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
C=[0.000 -1.000 +1.000 0.000 0.000 0.000 0.000 0.000 0.000];
J=1;% Number of rows in the contrast vector


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
            m_lh=GeneralizedLinearModel.fit(X,y_lh);
            m_rh=GeneralizedLinearModel.fit(X,y_rh);
            [p_lh,F_lh]=coefTest(m_lh,C);
            [p_rh,F_rh]=coefTest(m_rh,C);
            
            Output.FcalcM.Label(i).lh.Depth(j)=F_lh;
            Output.FcalcM.Label(i).rh.Depth(j)=F_rh;
            
            Output.PcalcM.Label(i).lh.Depth(j)=p_lh;
            Output.PcalcM.Label(i).rh.Depth(j)=p_rh;
        end
        
    end
end
    

