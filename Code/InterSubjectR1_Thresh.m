%Name:Hossein Rejali
%Superviser:Dr.Ali Khan
%Date:December 19th 2017
%Title: Threshold R1 Volume

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
        cd([Subj_ID,subjNUM,'/mri']);
        R1=MRIread('R1.mgz');
        Thresh=R1.vol>0 & R1.vol<10;
        R1_Thresh=R1;
        R1_Thresh.vol=R1.vol.*Thresh;
        save_mgh(R1_Thresh.vol,'R1_Thresh.mgh',R1.vox2ras);
    end
   
        %do nothing
        
 cd('../..')
    
end