%%Cross tab of HEPC status by years of injection
%0 years; 1-2 years; 3-4 years; 5-6 years; 7 or more years
load filtered_final_2015_05_06
load GENDER
load AGES

[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 

inj='InjBehavior_Note1/InjBehavior_Note2/InjBehavior_1'; 
indx=find(strcmp(headers,inj)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx_inj=find(data_mat==1); 

INJECTORS=filtered_data(indx_inj,:); 
GENDER_=GENDER(indx_inj); 
AGES_=AGES(indx_inj)'; 

[r,c]=size(INJECTORS); 
H='hiv_hcv: hepatitis C Test Results'; 
Y='FirstInj_Note1/FirstInj_2'; 

results=cell(6,3); 
results{1,1}='Years of injecting'; 
results{2,1}='0 years'; 
results{3,1}='1-2 years'; 
results{4,1}='3-4 years'; 
results{5,1}='5-6 years'; 
results{6,1}='7 years'; 
results{1,2}='HCV-'; 
results{1,3}='HCV+'; 

indx_Y=find(strcmp(headers,Y)==1); 
indx_H=find(strcmp(headers,H)==1);
data_Y=INJECTORS(:,indx_Y);
data_H=INJECTORS(:,indx_H); 

indx_nan=find(strcmp('NaN', data_Y)==1); 
for j=1:numel(indx_nan)
    data_Y{indx_nan(j)}=NaN; 
end  
data_Y2=cell2mat(data_Y);
data_Y3=floor(AGES_-data_Y2); 

indx_nan=find(strcmp('NaN', data_H)==1); 
for j=1:numel(indx_nan)
    data_H{indx_nan(j)}=NaN; 
end  
data_H2=cell2mat(data_H);
data_H2(data_H2==77)=NaN;
data_H2(data_H2==88)=NaN;
data_H2(data_H2==99)=NaN;

for j=1:2
    h=j-1; 
    indx_H0=find(data_H2==0); 
    indx_H1=find(data_H2==1); 
    for k=1:5
        if k==1
            indx=find(data_Y3==0); 
        elseif k==2
            indx=find(data_Y3==1 | data_Y3==2); 
        elseif k==3
            indx=find(data_Y3==3 | data_Y3==4); 
        elseif k==4
            indx=find(data_Y3==5 | data_Y3==6); 
        else
            indx=find(data_Y3>6); 
        end 
        indx_final0=intersect(indx_H0, indx); 
        indx_final1=intersect(indx_H1, indx); 
        results{k+1,2}=numel(indx_final0); 
        results{k+1,3}=numel(indx_final1); 
    end 
end 
 