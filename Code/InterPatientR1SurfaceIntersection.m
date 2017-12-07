%Name:Hossein Rejali
%Superviser:Dr.Ali Khan
%Date:July 13th 2017
%Title:Determine Intersection of Surface Files

%%
%..............................Description................................
% 1)Finds a matrix of zero and ones which corresponds to a space in which
% corresponds to the intersection of all the surface files
% 2) Once such a matrix is found the program will use this to mask all the
% existing files
% 3) At this point they modified files will be saved back to the original
% directory
%Note anat15 does not contain correct files, does not contain R1.mgz files
%..........................................................................
%%
%............................Initialization..............................
DepthIndex=2;
cd('/home/hrejali/alik_schizmyelin/freesurfer');
Subj_ID='anat3T';
Struct=struct;
%DepthString={'Depth1','Depth2','Depth3','Depth4','Depth5'};
ProjectionTypeString={'dist','frac'};
DepthString={'Depth1','Depth2'};
Depth=[2 5];
%%
%...................1) Storing Files Into Structure........................

for i=1:41
    if i <= 9
        Subj_ID=[Subj_ID,'0',int2str(i)];
    else
        Subj_ID=[Subj_ID,int2str(i)];
    end
    cd([Subj_ID,'/surf']);
    

    for j=1:length(ProjectionTypeString)
        if i==15
            continue;
        end
   
        
        s1=['lh.R1_','proj',ProjectionTypeString{j},'0.',int2str(Depth(j)),'.fsaverage','.mgh'];
        s2=['rh.R1_','proj',ProjectionTypeString{j},'0.',int2str(Depth(j)),'.fsaverage','.mgh'];
        
        File_mgh_lh=MRIread(s1);
        File_mgh_rh=MRIread(s2);
        
        %Thresholding surface files anything greater than zero and storing
        Struct.lh(i).R1.(DepthString{j})=File_mgh_lh.vol(:,:,:);
        Struct.rh(i).R1.(DepthString{j})=File_mgh_rh.vol(:,:,:);
        
        %Thresholding surface files anything greater than zero and storing
        Struct.lh(i).R1Thresh.(DepthString{j})=File_mgh_lh.vol(:,:,:)>0;
        Struct.rh(i).R1Thresh.(DepthString{j})=File_mgh_rh.vol(:,:,:)>0;
        
    end
    
    Subj_ID='anat3T';
    cd('../..')
end
%%
%.......................2) Producing Mask ...............................
% Index 15 refers to curvature data and not a R1 map
Struct.lh(15).R1 = [];
Struct.lh(15).R1Thresh = [];
Struct.rh(15).R1 = [];
Struct.rh(15).R1Thresh = [];
[l1 l2]=size(File_mgh_lh.vol);
ROutput=ones(l1,l2);
LOutput=ones(l1,l2);
for i=1:41
    for j=1:DepthIndex
        try
            LOutput=Struct.lh(i).R1Thresh.(DepthString{j}).*LOutput;
            ROutput=Struct.rh(i).R1Thresh.(DepthString{j}).*ROutput;
        catch
            
        end
    end
end
%%
%.......................3) Masking Process...............................
for i=1:41
    if i==15
        continue;
    end
    for j=1:DepthIndex
        try
            Struct.rh(i).R1Mod.(DepthString{j})=Struct.rh(i).R1.(DepthString{j}).*ROutput;
            Struct.lh(i).R1Mod.(DepthString{j})=Struct.lh(i).R1.(DepthString{j}).*LOutput;
        catch
            Struct.lh(i).R1Mod.(DepthString{j})=Struct.lh(i).R1.(DepthString{j})'.*LOutput;
            Struct.rh(i).R1Mod.(DepthString{j})=Struct.rh(i).R1.(DepthString{j})'.*ROutput;
            
        end
    end
end
%%
%.......................4) Saving Process ...............................
cd('/home/hrejali/alik_schizmyelin/freesurfer');

for i=1:41
    if i <= 9
        Subj_ID=[Subj_ID,'0',int2str(i)];
    else
        Subj_ID=[Subj_ID,int2str(i)];
    end
    cd([Subj_ID,'/surf']);
    
    for j=1:DepthIndex
        if i==15
            continue;
        end
        
        %This is a hack used to encode diffrent depths in the FWHM
        fwhm=j*5;
        s1=['lh.R1_','proj',ProjectionTypeString{j},'0.',int2str(Depth(j)),'.fsaverage','.Intersection','.mgh'];
        s2=['rh.R1_','proj',ProjectionTypeString{j},'0.',int2str(Depth(j)),'.fsaverage','.Intersection','.mgh'];
        
        LVol=Struct.lh(i).R1Mod.(DepthString{j});
        RVol=Struct.rh(i).R1Mod.(DepthString{j});
        
        %saving files
        save_mgh(LVol',s1,File_mgh_lh.vox2ras);
        save_mgh(RVol',s2,File_mgh_rh.vox2ras);
        
    end
    
    Subj_ID='anat3T';
    cd('../..')
end