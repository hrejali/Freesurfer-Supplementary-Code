%Name:Hossein Rejali
%Superviser:Dr.Ali Khan
%Date:June 15th 2017
%Title:Determing Reliable Structures to Investigate R1 Maps in Alzheimer Patients 

%%
%..............................Description................................
% Due to limited FOV, some structures are missing in the T1 Map. The
% following script will determine % of the diffrent structures specified by
% in the mgz volume data. NOTE: depending on the volume data imported it
% will specify a set of structures. We will be using the aparc.a2009s+aseg.mgz
% file. NOTE the volume data is not MRI intesnities rather a values for LUT
% which specify specific structures. 
%
% Depending on the structure of intrest you will import the volume data
% and pass this to PercentCov function which will determine the % of each
% label in that file  
%..........................................................................
%%
clc;
clear;

%%
%........................Run Through Patients of Interest.................

%Change directory to containing all the patients of interest 
Path='/home/hrejali/khangrp/users/alik/projects/SchizNottingham7T_Lena/vasst-dev/freesurfer';
LUT=LUTImport;
Subj_ID='anat3T';
volName='aparc.a2009s+aseg.mgz';

Table=LUT;
output=struct;
for i=1:41
    if i <= 9
        Subj_ID=[Subj_ID,'0',int2str(i)];
    else
        Subj_ID=[Subj_ID,int2str(i)];

    end
    % in the case where R1.mgz file is not found
    try
        output(i).Patient=PercentCov(volName,Subj_ID,Path,LUT);
    catch
        output(i).Patient=[];
    end
    Subj_ID='anat3T';
end

