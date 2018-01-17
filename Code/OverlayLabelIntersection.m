%Name:Hossein Rejali
%Superviser:Dr.Ali Khan
%Date:November 27th 2017
%Title: OverlayLabelIntersection

%%
%..............................Description................................
%NOTE!!! MUST CHANGE SUBJECTS_DIR to DIRECTORY WHERE YOU KEEP LABELS
%Summary:Extracts intensities from surface overlay corresponding to a particular label

% 1) Read in Overlay data, threshold the data (R1>0), Read in Label file
% 2) Obtain indicies corresponding to label
% 3) Store data that is > 0 and < 10


function [Struct]=OverlayLabelIntersection(Annot,subjNUM)
%%
%............................Initialization..............................
fsHome='/home/hrejali/alik_schizmyelin/freesurfer';
cd(fsHome);
Subj_ID='anat3T';
Struct=struct;
ProjectionTypeString={'dist','frac'};
Depth=[2 5];
%Annot='aparc.a2009s';
%subjNUM='01'

%%
%...................1)LOAD ANNOT FILE........................

[~,~,colortable]=read_annotation(['./fsaverage/label/','lh.',Annot,'.annot']);

%obtain names of labels in the file
Struct.LabelName=colortable.struct_names;

%...................2) Obtain Surface Overlay  ........................
for i=1:2
    s1=['lh.R1_','proj',ProjectionTypeString{i},'0.',int2str(Depth(i)),'.fsaverage','.mgh'];
    s2=['rh.R1_','proj',ProjectionTypeString{i},'0.',int2str(Depth(i)),'.fsaverage','.mgh'];
    
    Overlay_lh=MRIread(['./',Subj_ID,num2str(subjNUM),'/surf/',s1]);
    Overlay_rh=MRIread(['./',Subj_ID,num2str(subjNUM),'/surf/',s2]);
    
    %...................2) Obtain Surface Overlay  ........................
    
    Struct.Overlay(i).lh=Overlay_lh;
    Struct.Overlay(i).rh=Overlay_rh;
    %...................3) Struct Info ........................
    Struct.OverlayInfo(i)=string([ProjectionTypeString{i},'0.',num2str(Depth(i))]);
    %...................4) Threshold Data  ........................
    OverlayThresh_lh=Overlay_lh.vol>0 & Overlay_lh.vol<10 ;
    OverlayThresh_lh=Overlay_lh.vol.*OverlayThresh_lh;
    OverlayThresh_lh(OverlayThresh_lh==0)=nan;
    
    OverlayThresh_rh=Overlay_rh.vol>0 & Overlay_rh.vol<10;
    OverlayThresh_rh=Overlay_rh.vol.*OverlayThresh_rh;
    OverlayThresh_rh(OverlayThresh_rh==0)=nan;

    Struct.OverlayThresh(i).lh=OverlayThresh_lh;
    Struct.OverlayThresh(i).rh=OverlayThresh_rh;
    
    
end

%...................5)Run Through Label Files  ........................
cd(['./mask/','label/',Annot,'_Labels']);
LabelDir=[Annot,'_Labels'];
setenv('SUBJECTS_DIR','/home/hrejali/alik_schizmyelin/freesurfer')
%NOTE:read_label(aug1,aug2) will read label in SUBJECT_DIR/aug1/label/aug2
for i=1:length(colortable.struct_names)
    label_lh=read_label('mask',[LabelDir,'/lh.',colortable.struct_names{i}]);
    label_rh=read_label('mask',[LabelDir,'/rh.',colortable.struct_names{i}]);
    try
        Struct.Label(i).lh=label_lh(:,1);
        Struct.Label(i).rh=label_rh(:,1);
    catch
        Struct.Label(i).lh=[];
        Struct.Label(i).rh=[];
    end
    
end



end