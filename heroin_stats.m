load filtered_db_2015_02_24
load GENDER
FILE_IN=fopen('heroin_statistics.txt', 'wt'); 
[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 

%1: # people used POs nonmedically 
%Benchmark_Note1/Benchmark_13
%How old were you when you first used prescription opioids non-medically? 
PO_age='Benchmark_Note1/Benchmark_13';
indx=find(strcmp(headers,PO_age)==1); 
indx_male=find(GENDER==1); 
indx_female=find(GENDER==2); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
ages=data_mat; 
mean_age=nanmean(ages); 
        
M_ages=nanmean(ages); 
M_female=nanmean(ages(indx_female)); 
M_male=nanmean(ages(indx_male)); 

std_ages=nanstd(ages); 
std_male=nanstd(ages(indx_male)); 
std_female=nanstd(ages(indx_female)) ; 

min_age=min(ages); 
max_age=max(ages); 
min_female=min(ages(indx_female)); 
min_male=min(ages(indx_male)); 
max_female=max(ages(indx_female)); 
max_male=max(ages(indx_male)); 

range_ages=[num2str(sprintf('%.2f', min_age)) '-' num2str(sprintf('%.2f',max_age))]; 
range_male=[num2str(sprintf('%.2f',min_male)) '-' num2str(sprintf('%.2f',max_male))];
range_female=[num2str(sprintf('%.2f',min_female)) '-' num2str(sprintf('%.2f',max_female))]; 

fprintf(FILE_IN, '%s\n', 'Age'); 
temp=['Mean Age: Total ' num2str(sprintf('%.2f',M_ages)) ', Male ' num2str(sprintf('%.2f', M_male)) ', Female ' num2str(sprintf('%.2f', M_female))]; 
fprintf(FILE_IN, '%s\n', temp); 
temp=['StdDev Age: Total ' num2str(sprintf('%.2f',std_ages)) ', Male ' num2str(sprintf('%.2f', std_male)) ', Female ' num2str(sprintf('%.2f', std_female))];
fprintf(FILE_IN, '%s\n', temp); 
temp=['Age Range: Total ' range_ages ', Male ' range_male ', Female ' range_female];
fprintf(FILE_IN, '%s\n\n', temp); 

%print the % of people who have used 
indx=find(ages>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total)*100; 
m2=intersect(indx,indx_male); 
p_m=(numel(m2)/numel(indx_male))*100; 
f2=intersect(indx,indx_female); 
p_f=(numel(f2)/numel(indx_female))*100; 
fprintf(FILE_IN, '%s\n', '% of people who have used POs nonmedically');  
temp=['Total ' num2str(sprintf('%.1f',p)) ', Male ' num2str(sprintf('%.1f', p_m)) ', Female ' num2str(sprintf('%.1f', p_f))]; 
fprintf(FILE_IN, '%s\n', temp); 

%2: # people who have used heroin in their lifetimes 
%Benchmark_Note1/Benchmark_22
%How old were you when you first used heroin? 
heroin_age='Benchmark_Note1/Benchmark_22';
indx=find(strcmp(headers,heroin_age)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
heroin_ages=data_mat; 

indx=find(heroin_ages>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total)*100; 
m2=intersect(indx,indx_male); 
p_m=(numel(m2)/numel(indx_male))*100; 
f2=intersect(indx,indx_female); 
p_f=(numel(f2)/numel(indx_female))*100; 
fprintf(FILE_IN, '%s\n', '% of people who have used Heroin');  
temp=['Total ' num2str(sprintf('%.1f',p)) ', Male ' num2str(sprintf('%.1f', p_m)) ', Female ' num2str(sprintf('%.1f', p_f))]; 
fprintf(FILE_IN, '%s\n', temp); 
%use as denomintaros below
male_total_=numel(m2); 
total_=count; 
female_total_=numel(f2); 


%3: percent whom nonmedial PO use preceded heroin use 
%Benchmark_Note1/Benchmark_22-Benchmark_Note1/Benchmark_13
%if positive then YES
diff=heroin_ages-ages; 

indx=find(diff>0 & heroin_ages>0 & ages>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total_)*100; 
m2=intersect(indx,indx_male); 
p_m=(numel(m2)/male_total_)*100; 
f2=intersect(indx,indx_female); 
p_f=(numel(f2)/female_total_)*100; 
fprintf(FILE_IN, '%s\n', '% of people for whom nonmedical PO use preceded heroin use');  
temp=['Total ' num2str(sprintf('%.1f',p)) ', Male ' num2str(sprintf('%.1f', p_m)) ', Female ' num2str(sprintf('%.1f', p_f))]; 
fprintf(FILE_IN, '%s\n', temp); 

%4: percent for whom heroin use preceded nonmedical PO use
%same as 3 but if negative then YES
indx=find(diff<0 & heroin_ages>0 & ages>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total_)*100; 
m2=intersect(indx,indx_male); 
p_m=(numel(m2)/male_total_)*100; 
f2=intersect(indx,indx_female); 
p_f=(numel(f2)/female_total_)*100; 
fprintf(FILE_IN, '%s\n', '% of people for whom nonmedical heroin use preceded PO use');  
temp=['Total ' num2str(sprintf('%.1f',p)) ', Male ' num2str(sprintf('%.1f', p_m)) ', Female ' num2str(sprintf('%.1f', p_f))]; 
fprintf(FILE_IN, '%s\n', temp); 

%5: percent who first used POs nonmedically and heroin in the same year
%same as 3 but if 0 then YES
indx=find(diff==0 & heroin_ages>0 & ages>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total_)*100; 
m2=intersect(indx,indx_male); 
p_m=(numel(m2)/male_total_)*100; 
f2=intersect(indx,indx_female); 
p_f=(numel(f2)/female_total_)*100; 
fprintf(FILE_IN, '%s\n', '% of people who first used nonmedical PO use and heroin use in the same year');  
temp=['Total ' num2str(sprintf('%.1f',p)) ', Male ' num2str(sprintf('%.1f', p_m)) ', Female ' num2str(sprintf('%.1f', p_f))]; 
fprintf(FILE_IN, '%s\n', temp); 

%6: percent who report using POs nonmedically in past 30 days
%DaysSU_Note1/DaysSU_6
%How many days in the past 30 days, if any, have you used prescription opioids nonmedically? 
PO_30='DaysSU_Note1/DaysSU_6';
indx=find(strcmp(headers,PO_30)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
PO_use=data_mat; 

indx=find(PO_use>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total)*100; 
m2=intersect(indx,indx_male); 
p_m=(numel(m2)/numel(indx_male))*100; 
f2=intersect(indx,indx_female); 
p_f=(numel(f2)/numel(indx_female))*100; 
fprintf(FILE_IN, '%s\n', '% of people who have used POs nonmedically in the past 30 days');  
temp=['Total ' num2str(sprintf('%.1f',p)) ', Male ' num2str(sprintf('%.1f', p_m)) ', Female ' num2str(sprintf('%.1f', p_f))]; 
fprintf(FILE_IN, '%s\n', temp); 

%%%CHECK THAT THESE DON'T SAY 'DAYS' IN THE CELLS!!!!!!!!
%percent who report using heroin in past 30 days 
%DaysSU_Note1/DaysSU_1
%How many days, if any, have you used heroin by itself (eg not speedballs) in the past 30? 
heroin_30='DaysSU_Note1/DaysSU_1';
indx=find(strcmp(headers,heroin_30)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
heroin_use=data_mat; 

indx=find(heroin_use>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total)*100; 
m2=intersect(indx,indx_male); 
p_m=(numel(m2)/numel(indx_male))*100; 
f2=intersect(indx,indx_female); 
p_f=(numel(f2)/numel(indx_female))*100; 
fprintf(FILE_IN, '%s\n', '% of people who have used heroin in the past 30 days');  
temp=['Total ' num2str(sprintf('%.1f',p)) ', Male ' num2str(sprintf('%.1f', p_m)) ', Female ' num2str(sprintf('%.1f', p_f))]; 
fprintf(FILE_IN, '%s\n', temp); 

fclose(FILE_IN); 