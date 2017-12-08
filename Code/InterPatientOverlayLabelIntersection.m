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
Annot='aparc.a2009s';
Output=struct;
temp=OverlayLabelIntersection(Annot,'01');
Output.LabelName=temp.LabelName;
Output.Label=temp.Label;
Output.Subj(1).Overlay=temp.Overlay;
Output.Subj(1).OverlayThresh=temp.OverlayThresh;

for i=2:41
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

%Storing Mean values at a particular label for each patient and depth

for i=1:42
    for j=1:length(Output.LabelName)
        for k=1:2
            try
                Output.Subj(i).LabelMean(j).lh.Depth(k)=mean(Output.Subj(i).OverlayThresh(k).lh(Output.Label(j).lh));
                Output.Subj(i).LabelMean(j).rh.Depth(k)=mean(Output.Subj(i).OverlayThresh(k).rh(Output.Label(j).rh));
                
            catch
                
            end
        end
    end
end

%%
%Creating plots for the mean values 


for j=1:76
    for i=1:41
        if(i==15)
            x(i)=0;continue;
        end
        try
            RH_Mean(i)=Output.Subj(i).LabelMean(j).rh.Depth(1);
            LH_Mean(i)=Output.Subj(i).LabelMean(j).lh.Depth(1);
 
        end
    end
    try
        subplot(4,19,j); scatter(1:41,RH_Mean); %title(Output.LabelName(j));xlabel('Subjects');ylabel('Mean R1 Intensity')
        hold on;
        subplot(4,19,j); scatter(1:41,LH_Mean,'r'); %title(Output.LabelName(j));xlabel('Subjects');ylabel('Mean R1 Intensity')

    end
    
end
scatter(1:41,x)