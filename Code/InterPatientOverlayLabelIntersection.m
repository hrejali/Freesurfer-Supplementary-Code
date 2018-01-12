%Name:Hossein Rejali
%Superviser:Dr.Ali Khan
%Date:December 6th 2017
%Title: Intersubject OverlayLabelIntersection

%%
%..............................Description................................
%Summary:Extracts intensities from surface overlay corresponding to a
%particular label for each subject. Next do statistical analysis on region
%of interests

%%
%Annot='aparc.a2009s';
Annot='GLM_Analyses';
Output=struct;
temp=OverlayLabelIntersection(Annot,'01');
Output.LabelName=temp.LabelName;
Output.Label=temp.Label;
Output.Subj(1).Overlay=temp.Overlay;
Output.Subj(1).OverlayThresh=temp.OverlayThresh;

%initializing variables
NumSubj=41;
NumLabel=length(Output.LabelName);
NumDepth=2;

for i=2:NumSubj
    if i <= 9
        subjNUM=['0',int2str(i)];
    else
        subjNUM=int2str(i);
        
    end
    try
        temp=OverlayLabelIntersection(Annot,subjNUM);
        Output.Subj(i).Overlay=temp.Overlay;
        Output.Subj(i).OverlayThresh=temp.OverlayThresh;
    catch
        %do nothing
        
    end
end
%%
%Storing Mean values at a particular label for each patient and depth

for i=1:NumSubj
    for j=1:NumLabel
        for k=1:NumDepth
            try
                Output.Subj(i).LabelMean(j).lh.Depth(k)=mean(Output.Subj(i).OverlayThresh(k).lh(Output.Label(j).lh));
                Output.Subj(i).LabelMean(j).rh.Depth(k)=mean(Output.Subj(i).OverlayThresh(k).rh(Output.Label(j).rh));
                
                
            catch
                
            end
        end
    end
end

%%
%............Creating plots for the mean Intensity values................

%Determines if NumLabel is a perfect sqaure
if ((sqrt(NumLabel)-round(sqrt(NumLabel)))==0)
    dim=sqrt(NumLabel);
else
    dim=sqrt(NumLabel)+1;
end

for i=1:NumDepth
    for j=1:NumLabel
        for k=1:NumSubj
            if(k==15)
                continue;
            end
            try
                RH_Mean(k)=Output.Subj(k).LabelMean(j).rh.Depth(i);
                LH_Mean(k)=Output.Subj(k).LabelMean(j).lh.Depth(i);
                
                Output.MeanAcrossSubj(j).rh.Depth(i)=mean(RH_Mean);
                Output.STDAcrossSubj(j).rh.Depth(i)=std(RH_Mean);
                
                Output.MeanAcrossSubj(j).lh.Depth(i)=mean(LH_Mean);
                Output.STDAcrossSubj(j).lh.Depth(i)=std(LH_Mean);
                
            end
            
        end
        try

            subplot(dim,dim,j); scatter(1:NumSubj,RH_Mean); 
            hold on;
            subplot(dim,dim,j); scatter(1:NumSubj,LH_Mean,'r');
            
            STDThresh_rh=3*Output.STDAcrossSubj(j).rh.Depth(i)*ones(41)+Output.MeanAcrossSubj(j).rh.Depth(i)*ones(41);
            STDThresh_lh=3*Output.STDAcrossSubj(j).lh.Depth(i)*ones(41)+Output.MeanAcrossSubj(j).rh.Depth(i)*ones(41);
            %hold on;
            %subplot(4,19,j); plot(1:41,Output.MeanAcrossSubj(j).rh.Depth(i)*ones(41),'g--');
            hold on;
            subplot(dim,dim,j); plot(1:NumSubj,STDThresh_rh,'r--');
            hold on;
            subplot(dim,dim,j); plot(1:NumSubj,STDThresh_lh,'b--');
            xlim([0 NumSubj])
            title(Output.LabelName(j));
            xlabel('Subjects');
            ylabel('Mean R1 Intensity')

        end

    end
         figure;

end

