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



for i=1:42
    for j=1:length(Output.LabelName)
        try
        Output.Subj(i).LabelMean(j)=mean(Output.Subj(i).OverlayThresh(i).lh(Output.Label(j).lh));
        catch
            
        end

    end
end
%Struct.OverlayThresh(1).lh(Struct.Label(7).lh)