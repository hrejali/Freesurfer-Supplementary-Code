function [ Output ] = PercentCovDisplay(Struct,Index_lh,Index_rh,StringName)
for i=1:41
    if(i==15)
        x_lh(i)=0;
        x_rh(i)=0;
        continue;
    end
    x_lh(i)=Struct(i).Patient(Index_lh).Percentage;
    x_rh(i)=Struct(i).Patient(Index_rh).Percentage;
end
figure;
scatter(1:41,x_lh,'r');
hold on;
scatter(1:41,x_rh,'b')
xlabel('Subjects');
ylabel('Percentage(%)');

 if ~exist('StringName','var')
     % third parameter does not exist, so default it to something
      StringName = 'Percentage Covered For Each Subject';
 else
     StringName=['Percentage Covered For The ',StringName, newline,'For Each Subject'];
 end
title(StringName);
legend('Left Hemi','Right Hemi');
end