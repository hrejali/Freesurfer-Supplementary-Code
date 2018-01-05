%Name:Hossein Rejali
%Superviser:Dr.Ali Khan
%Date:December 19th 2017
%Title: DataPercentage

%%
%..............................Description................................
%Summary:Threshold R1 Volume

fsHome='/home/hrejali/alik_schizmyelin/freesurfer';
cd(fsHome);
Subj_ID='anat3T';

for i=1:41
    if i==15
        continue;
    end
    if i <= 9
        subjNUM=['0',int2str(i)];
    else
        subjNUM=int2str(i);
        
    end
    try
        cd([Subj_ID,subjNUM,'/surf']);
        lh_R1=MRIread('lh.R1_projdist0.2.Thresh.fsaverage.mgh');
        rh_R1=MRIread('rh.R1_projdist0.2.Thresh.fsaverage.mgh');
        Struct.dist.fsaverage.Thresh.lh.Percentage(i)=sum(lh_R1.vol>0)/lh_R1.width*100;
        Struct.dist.fsaverage.Thresh.rh.Percentage(i)=sum(rh_R1.vol>0)/rh_R1.width*100;

   
    end
   
        %do nothing
        
 cd('../..')
    
end