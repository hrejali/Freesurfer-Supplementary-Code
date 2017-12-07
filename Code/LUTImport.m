function [output]=LUTImport
%Reads the LUT.txt file in the following directory:
%'/home/hrejali/Documents/Code'
%Creats a struct that cotians the index for each label NumArray
%each index in Numarray corresponds to the label it refers to in Name field

cd('/home/hrejali/Documents/Projects/SchizProject')
fid = fopen('LUT.txt');
tline = fgets(fid);

i=1;
output=struct;
C = strsplit(tline);
output(i).LUT=str2double(regexp(tline,'^\d+','match'));
output(i).Name=regexp(tline,'([a-z]\w+|[A-Z]\w+','match');
tline = fgets(fid);

while ischar(tline)
    i=i+1;
    disp(tline)
    output(i).LUT=str2double(regexp(tline,'^\d+','match'));
    if ~isempty(output(i).LUT)
        C = strsplit(tline);
        output(i).Name=C(2);
    end
    tline = fgets(fid);

end

%This section removes all the empty index's
j=1;
for i=1:length(output)
    if isempty(output(i).Name)
        index(j)=i;
        j=j+1;
    end
    
end
output(index)=[];


fclose(fid);

end

