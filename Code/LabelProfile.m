function [ Struct ] = Label2ProfileStruct( subj_name,label_name,Profdir,fwhm)
%add path to directory that contains labels of patient
%Input: 1) Subject name as a string
%       2) Label Name (repersenting a particular area in brain ex) Primary
%       Visual cortex) DO NOT include lh. amd rh. in name
%       3) Path to directory that contains all the depth files
%       4) Specify the FWHM 

%....................Counting Number of Relavent Files.....................
%%
%Hard Coding Function Parameters
subj_name='anat3T01';
NumDepth=0;
label_name='V1'
fwhm=1;

%Ex)lh.R1_projdist#.fwhm#.mgh
Profdir='/home/hrejali/khangrp/users/alik/projects/SchizNottingham7T_Lena/vasst-dev/freesurfer/anat3T01/surf';
cd(Profdir)

for i=1:9
s1=['lh.R1_projfrac',num2str(i),'.fwhm',num2str(fwhm),'.mgh'];

d1=dir(s1); % there should be equal number of l and r
NumDepth=length(d1)+NumDepth;
if length(d1) ~= 0
    index(i)=i
else
    index(i)=0;
end

end
Index=index(index~=0);

%....................Check for user Error in Input........................
%%
if NumDepth==0
    disp('ERROR:Files Do Not Exist or Cannot Be Found')
    return
end

%....................Creating Sturct and Storing........................
%%
Struct=struct;    
label_lh=read_label('anat3T01',['lh.',label_name]);
label_rh=read_label('anat3T01',['rh.',label_name]);


for i=1:NumDepth
    s1=['lh.R1_projfrac',num2str(Index(i)),'.fwhm',num2str(fwhm),'.mgh'];
    s2=['rh.R1_projfrac',num2str(Index(i)),'.fwhm',num2str(fwhm),'.mgh'];
    
    File_mgh_lh=MRIread(s1);
    File_mgh_rh=MRIread(s2);
    
    %storing values relevant to particular label (eg.brain region)
    
    %Make a case to check if the .mgh exist and was correctly read
    if ~isempty(File_mgh_lh)
        Struct(i).lh=File_mgh_lh.vol(label_lh(:,1)+1);
    end
    if ~isempty(File_mgh_rh)
        Struct(i).rh=File_mgh_rh.vol(label_rh(:,1)+1);
    end
    
    
end

%Creating Profile for individel voxels in region of interest
for j=1:length(label_lh)
    for k=1:NumDepth
        Struct(j).profile_lh(k)= Struct(k).lh(j);
        Struct(j).profile_rh(k)= Struct(k).rh(j);

    end
end


end

