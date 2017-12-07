function [ Output ] = PercentCov(VolName,Subj_ID,Path,LUT )
%add path to directory that contains labels of patient
%Input:  1) Volume Name (volume data repersenting a LUT intensity of
%selection of regions in brain)
%        2) Subject name as a string
%        3) Path to directory that contains all the depth files
%        4) Look up table
%Output: 1) Struct that contains name of label and % of coverage


%Hard Coding Function Parameters
%Path='/home/hrejali/khangrp/users/alik/projects/SchizNottingham7T_Lena/vasst-dev/freesurfer/anat3T01/mri';
Path=[Path,'/',Subj_ID,'/mri'];
%Path=['/usr/local/freesurfer/subjects/',subj_name,'/surf'];
cd(Path)
%.............................Reading In T1 Map ..........................
%%
Mask=MRIread('brainmask.mgz');
try
    R1Map=MRIread('R1.mgz');
catch
    disp('ERROR:R1.mgz Does Not Exist or Cannot Be Found')
    return;
end


%............................Thresholding T1 Map .........................
%%
Mask_Thresh=Mask.vol(:,:,:)>0;
[l w h]=size(R1Map);
R1Map_Mask=Mask_Thresh.*R1Map.vol;
R1_Thresh=zeros(l,w,h);
R1_Thresh=R1Map_Mask(:,:,:)>0;
%.......................Reading In Annotation File........................
%%
%cd('../label')
%
%[R_Vertices R_Label R_ctab]=read_annotation('rh.aparc.a2009s.annot');

%.......................Reading In aparc+aseg File........................
%cd('../mri')
%AparcAseg_MGZ=MRIread('aparc.a2009s+aseg.mgz');
VolData=MRIread(VolName);
%.......................Reading In FreeSurtferColorLUT........................

Output=LUT; % Avoid calling LUTImport when calling this function multiple times

%..............Determine number of missing voxels in each label...........
%%
Length=length(Output);

%This is Threshold T1 map multiplied by AparcAseg_MGZ matrix
VolDataTresh=R1_Thresh.*VolData.vol;

for i=1:Length

    TotalCount=length(find(VolData.vol==Output(i).LUT));
    
    Count=length(find(VolDataTresh==Output(i).LUT));
    
    if TotalCount>0
        Output(i).Percentage=Count/TotalCount*100;
    end
    
end


end


