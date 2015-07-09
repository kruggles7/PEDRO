load filtered_final_2015_05_06
load AGES
[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 
z=1.96;
OD='Overdose_8'; 

indx=find(strcmp(headers,OD)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx_OD=find(data_mat==1); 
indx_noOD=find(data_mat==0); 
indx_all=find(data_mat==1 | data_mat==0); 

OVERDOSE=filtered_data(indx_OD,:); 
AGES=round(AGES(indx_OD)); 


results=cell.empty; 
results{1,1}='Question'; 
results{1,2}='Code'; 
results{1,3}='Mean OD'; 
results{1,4}='SD OD';
results{1,5}='95% CI OD';
results{1,6}='Mean no OD'; 
results{1,7}='SD no OD';
results{1,8}='95% CI no OD'; 
results{1,9}='pvalue'; 

%TOtal number of people they know who inject drugs NetChar_22
A='NetChar_Note1/NetChar_22';  
results{2,1}='Number of people they know who inject drugs';  

indx=find(strcmp(headers,A)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 

data_OD=data_mat(indx_OD); 
statmat(1:numel(data_OD),1)=data_OD; 
m=nanmean(data_OD); 
s=nanstd(data_OD); 
results{2,3}=sprintf('%0.1f',m);
results{2,4}=sprintf('%0.1f',s);
N=numel(indx_OD); 
upper=m+z*s/sqrt(N); 
lower=m-z*s/sqrt(N);
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
results{2,5}=[lower '-' upper]; 

data_noOD=data_mat(indx_noOD); 
statmat(1:numel(data_noOD),2)=data_noOD; 
m=nanmean(data_noOD); 
s=nanstd(data_noOD); 
results{2,6}=sprintf('%0.1f',m);
results{2,7}=sprintf('%0.1f',s);
N=numel(indx_noOD); 
upper=m+z*s/sqrt(N); 
lower=m-z*s/sqrt(N);
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
results{2,8}=[lower '-' upper]; 
[h,p]=ttest2(statmat(:,1), statmat(:,2)); 
results{2,9}=p; 

%How many people do you know of heroin and PO users who are 18-29 
%who you have seen in the last 30 days
A='Lastquestion';

results{3,1}='Number of people they know who are heroin and PO users 18-29 seen in the last 30 days'; 
indx=find(strcmp(headers,A)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 

data_OD=data_mat(indx_OD); 
statmat(1:numel(data_OD),1)=data_OD; 
m=nanmean(data_OD); 
s=nanstd(data_OD); 
results{3,3}=sprintf('%0.1f',m);
results{3,4}=sprintf('%0.1f',s);
N=numel(indx_OD); 
upper=m+z*s/sqrt(N); 
lower=m-z*s/sqrt(N);
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
results{3,5}=[lower '-' upper]; 

data_noOD=data_mat(indx_noOD); 
statmat(1:numel(data_noOD),2)=data_noOD; 
m=nanmean(data_noOD); 
s=nanstd(data_noOD); 
results{3,6}=sprintf('%0.1f',m);
results{3,7}=sprintf('%0.1f',s);
N=numel(indx_noOD); 
upper=m+z*s/sqrt(N); 
lower=m-z*s/sqrt(N);
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
results{3,8}=[lower '-' upper]; 
[h,p]=ttest2(statmat(:,1), statmat(:,2)); 
results{3,9}=p; 

%In the past 30 days how many people have you injected drugs with? NetInj_3
%
A='NetInj_Note1/NetInj_1_group/NetInj_3'; 

results{4,1}='Number of people in the last 30 days they have injected drugs with'; 
stat_mat=nan(260,2); 
x_plot=zeros(2,2); 
std_plot=zeros(2,2); 

indx=find(strcmp(headers,A)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 

data_OD=data_mat(indx_OD); 
statmat(1:numel(data_OD),1)=data_OD; 
m=nanmean(data_OD); 
s=nanstd(data_OD); 
results{4,3}=sprintf('%0.1f',m);
results{4,4}=sprintf('%0.1f',s);
N=numel(indx_OD); 
upper=m+z*s/sqrt(N); 
lower=m-z*s/sqrt(N);
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
results{4,5}=[lower '-' upper]; 

data_noOD=data_mat(indx_noOD); 
statmat(1:numel(data_noOD),2)=data_noOD; 
m=nanmean(data_noOD); 
s=nanstd(data_noOD); 
results{4,6}=sprintf('%0.1f',m);
results{4,7}=sprintf('%0.1f',s);
N=numel(indx_noOD); 
upper=m+z*s/sqrt(N); 
lower=m-z*s/sqrt(N);
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
results{4,8}=[lower '-' upper]; 
[h,p]=ttest2(statmat(:,1), statmat(:,2)); 
results{4,9}=p; 

