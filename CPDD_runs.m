load filtered_final_2015_05_06
FILE_IN=fopen('cpdd.txt', 'wt'); 

[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 

temp=['N recruited: ' num2str(r-1)]; 
fprintf(FILE_IN, '%s\n', temp); 

%1. LIMIT TO THOSE WHO INJECTED DRUGS IN THE LAST 12 MONTHS
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

[r,c]=size(INJECTORS); 
temp=['N injected in the last 12 months: ' num2str(r)]; 
fprintf(FILE_IN, '%s\n', temp); 


demograph={'Soc_Note1/Soc_10', 'Soc_Note1/Soc_3', 'Soc_Note1/Soc_5','Soc_Note1/Soc_4','Soc_Note1/Soc_19', 'Soc_Note1/Soc_22', 'Soc_Note1/Soc_23'};
%in order of header Gender, Age (DOB), Race, Ethnicity, Highest level of education

%find the frequency/percentage for all but the age, find mean, range and
%std
education={'Did not complete high school', 'High school graduate or GED', 'Some college/Associates degree', 'College graduate or more','NA'}; 
race={'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian/Pacific Islander', 'White', 'Multiracial'}; 
soc_class={'Affluent', 'Upper Middle Class', 'Middle Class', 'Lower Middle Class', 'Poor'}; 
%soc_23={'$0-$25,000', '$26,000-$50,000', '$51,000-$75,000', '$76,000-$100,000', '$101,000-$125,000', '$126,000-$150,000', '$151,000-$200,000', '$201,000-$250,000', '$251+'}; 
soc_23={'$0-$50,000', '$51,000-$100,000', '$101,000+'}; 


for i=1:numel(demograph)
    D=demograph{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=INJECTORS(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    
    if (i==1) %gender M=1, F=2, transgender=3,4
        data_mat=cell2mat(data_mat); 
        indx_male=find(data_mat==1); 
        indx_female=find(data_mat==2); 
        per_male=numel(indx_male)/numel(data_mat)*100; 
        fprintf(FILE_IN, '%s\n', 'Gender'); 
        per_female=numel(indx_female)/numel(data_mat)*100; 
        temp=['Number of Males: ' num2str(numel(indx_male))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent of Males: ' num2str(sprintf('%.1f', per_male)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Number of Females: ' num2str(numel(indx_female))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent of Females: ' num2str(sprintf('%.1f',per_female)) '%']; 
        fprintf(FILE_IN, '%s\n\n', temp); 
        GENDER=data_mat; %to use in the rest of the analysis
        
        s1=per_female+per_male
        
    elseif (i==2) %DATE OF BIRTH
        today='Soc_Note1/Soc_1'; 
        indx_today=find(strcmp(headers,today)==1); 
        today_mat=INJECTORS(:,indx_today); 
        birth_date=data_mat; 
        ages=double.empty; 
        %fix_dates
        for j=1:numel(today_mat)
            temp=today_mat{j}; 
            new_temp=strrep(temp, '.', '/'); 
            TODAY=strrep(new_temp, '-', '/'); 
            temp=birth_date{j}; 
            new_temp=strrep(temp, '.', '/'); 
            BIRTH=strrep(new_temp, '-', '/'); 
            if isnan(BIRTH)==0
                numdays=datenum(TODAY)-datenum(BIRTH); 
                numyears=numdays/365; 
                ages(j)=numyears; 
            else
                ages(j)=NaN; 
            end 
        end 
        AGES=ages; 
        
        M_ages=nanmean(ages); 
        std_ages=nanstd(ages); 
        
        min_age=min(ages); 
        max_age=max(ages); 
        range_ages=[num2str(sprintf('%.2f', min_age)) '-' num2str(sprintf('%.2f',max_age))]; 

        
        fprintf(FILE_IN, '%s\n', 'Age'); 
        temp=['Mean Age: Total ' num2str(sprintf('%.2f',M_ages)) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['StdDev Age: Total ' num2str(sprintf('%.2f',std_ages)) ];
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Age Range: Total ' range_ages ];
        fprintf(FILE_IN, '%s\n\n', temp); 
        
    elseif (i==3) %RACE
        race_mat=double.empty; %number race, % race, number male, %race male, number female, %race female
        indx_f= indx_female; 
        indx_m=indx_male; 
        %replace multiracial with '7'
        for j=1:r-1
            indx_multi=strfind(data_mat{j},' '); 
            if isempty(indx_multi)==0
                data_mat{j}=6; 
            end 
        end 
        data_mat=cell2mat(data_mat); 
        total_num=numel(data_mat); 
        
        fprintf(FILE_IN, '%s\n', 'Race'); 
        s=0; 
        for j=1:6
            indx_race=find (data_mat==j); 
            race_mat(j,1)=numel(indx_race); 
            race_mat(j,2)=numel(indx_race)/total_num*100; 
            male=intersect(indx_race,indx_male); 
            race_mat(j,3)=numel(male); 
            race_mat(j,4)=numel(male)/numel(indx_male)*100; 
            female=intersect(indx_race,indx_female); 
            race_mat(j,5)=numel(female); 
            race_mat(j,6)=numel(female)/numel(indx_female)*100; 
            s=s+race_mat(j,2); 
            
            temp=['Number of ' race{j} ': Total ' num2str(race_mat(j,1)) ]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' race{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2)))]; 
            fprintf(FILE_IN, '%s\n', temp);   
        end 
        indx_missing=find(data_mat>6 | isnan(data_mat)==1); 
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        male=intersect(indx_missing, indx_male); 
        m=numel(male); 
        m_p=numel(male)/numel(indx_male)*100; 
        female=intersect(indx_missing, indx_female); 
        f=numel(female); 
        f_p=numel(female)/numel(indx_female)*100; 
        temp=['Number of missing: Total ' num2str(n) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p)) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        RACE=data_mat; 
        fprintf(FILE_IN, '\n'); 
        s3=s+n_p
        
    elseif (i==4)
        %ETHNICITY (hispanic or nonhispanic)
        data_mat=cell2mat(data_mat); 
        indx_his=find(data_mat==1); 
        male=intersect(indx_his,indx_male); 
        female=intersect(indx_his,indx_female); 
        
        indx_total=find(data_mat==0 | data_mat==1); 
        indx_f=intersect(indx_total, indx_female); 
        indx_m=intersect(indx_total, indx_male); 
        
        per_total=numel(indx_his)/numel(data_mat)*100; 
        per_male=numel(male)/numel(indx_male)*100; 
        per_female=numel(female)/numel(indx_female)*100; 
        
        fprintf(FILE_IN, '%s\n', 'Hispanic/Latino'); 
        temp=['Number of Hispanic/Latino: Total ' num2str(numel(indx_his))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent of Hispanic/Latino: Total ' num2str(sprintf('%.1f',per_total))]; 
        fprintf(FILE_IN, '%s\n\n', temp); 
        
        s4=n+numel(indx_total) 
        
    elseif (i==5) %highest level of education
        data_mat=cell2mat(data_mat); 
        indx_total=find(data_mat>0 & data_mat<8); 
        total_num=numel(data_mat); %%CHANGED THIS 
        indx_f=intersect(indx_total, indx_female); 
        indx_m=intersect(indx_total, indx_male); 
        fprintf(FILE_IN, '%s\n', 'Education level'); 
        s=0; 
        for j=1:4
            if (j<4)
                indx_race=find (data_mat==j); 
            else
                indx_race=find (data_mat>=j & data_mat<7); 
            end 
            race_mat(j,1)=numel(indx_race); 
            race_mat(j,2)=numel(indx_race)/total_num*100; 
            male=intersect(indx_race,indx_male); 
            race_mat(j,3)=numel(male); 
            race_mat(j,4)=numel(male)/numel(indx_male)*100; 
            female=intersect(indx_race,indx_female); 
            race_mat(j,5)=numel(female); 
            race_mat(j,6)=numel(female)/numel(indx_female)*100; 
            
            temp=[education{j} ': Total ' num2str(race_mat(j,1))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' education{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2))) ]; 
            fprintf(FILE_IN, '%s\n', temp);   
            
            s=s+race_mat(j,2); 
        end 
        indx_missing=find(data_mat>6 | isnan(data_mat)==1);  
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        male=intersect(indx_missing, indx_male); 
        m=numel(male); 
        m_p=numel(male)/numel(indx_male)*100; 
        female=intersect(indx_missing, indx_female); 
        f=numel(female); 
        f_p=numel(female)/numel(indx_female)*100; 
        temp=['Number of missing: Total ' num2str(n) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p)) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        s5=s+n
        EDUCATION=data_mat; 
        fprintf(FILE_IN, '\n'); 
    elseif (i==6)
        data_mat=cell2mat(data_mat); 
        indx_total=find(data_mat>0 & data_mat<6); 
        total_num=numel(data_mat); 
        indx_f=intersect(indx_total, indx_female); 
        indx_m=intersect(indx_total, indx_male); 
        fprintf(FILE_IN, '%s\n', 'Socioeconomic Class'); 
        s=0; 
        for j=1:5
            indx_race=find (data_mat==j); 
            race_mat(j,1)=numel(indx_race); 
            race_mat(j,2)=numel(indx_race)/total_num*100; 
            male=intersect(indx_race,indx_male); 
            race_mat(j,3)=numel(male); 
            race_mat(j,4)=numel(male)/numel(indx_male)*100; 
            female=intersect(indx_race,indx_female); 
            race_mat(j,5)=numel(female); 
            race_mat(j,6)=numel(female)/numel(indx_female)*100; 
            
            temp=[soc_class{j} ': Total ' num2str(race_mat(j,1))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' soc_class{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2))) ]; 
            fprintf(FILE_IN, '%s\n', temp);   
            
            s=s+race_mat(j,2); 
        end 
            
        indx_missing=find(data_mat>5 | isnan(data_mat)==1); 
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        male=intersect(indx_missing, indx_male); 
        m=numel(male); 
        m_p=numel(male)/numel(indx_male)*100; 
        f=numel(female); 
        f_p=numel(female)/numel(indx_female)*100; 
        female=intersect(indx_missing, indx_female); 
        temp=['Number of missing: Total ' num2str(n) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        CLASS=data_mat; 
        fprintf(FILE_IN, '\n'); 
        s6=s+n_p 
    elseif i==7
        data_mat=cell2mat(data_mat); 
        indx_total=find(data_mat>0 & data_mat<10); 
        total_num=numel(data_mat); 
        fprintf(FILE_IN, '%s\n', 'Household Income'); 
        s=0; 
        race_mat=zeros(3,2); 
        
        for j=1:9
            indx_race=find (data_mat==j); 
            if j<3
                race_mat(1,1)= race_mat(1,1)+ numel(indx_race); 
            elseif j<5
                race_mat(2,1)=race_mat(2,1)+ numel(indx_race); 
            else 
                race_mat(3,1)=race_mat(3,1)+ numel(indx_race); 
            end 
        end 
        race_mat(:,2)=race_mat(:,1)/total_num*100; 
        
        for j=1:3
            temp=[soc_23{j} ': Total ' num2str(race_mat(j,1))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' soc_23{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2)))]; 
            fprintf(FILE_IN, '%s\n', temp);   
        end 
            
        s=s+sum(race_mat(:,2)); 
            
        indx_missing=find(data_mat>9 | isnan(data_mat)==1); 
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        temp=['Number of missing: Total ' num2str(n)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        INCOME=data_mat; 
        fprintf(FILE_IN, '\n'); 
        s7=s+n_p 
    end 
end 


%2: # people used POs nonmedically 
%Benchmark_Note1/Benchmark_13
%How old were you when you first used prescription opioids non-medically? 
PO_age='Benchmark_Note1/Benchmark_13';
indx=find(strcmp(headers,PO_age)==1); 
indx_male=find(GENDER==1); 
indx_female=find(GENDER==2); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
data_mat(data_mat==0)=NaN; 
data_mat(data_mat==77)=NaN;
data_mat(data_mat==88)=NaN;
data_mat(data_mat==99)=NaN; 

ages=data_mat;  
M_ages=nanmean(ages); 
std_ages=nanstd(ages); 
min_age=min(ages); 
max_age=max(ages); 

range_ages=[num2str(sprintf('%.2f', min_age)) '-' num2str(sprintf('%.2f',max_age))]; 

fprintf(FILE_IN, '%s\n', 'Age of PO initiation'); 
temp=['Mean Age: Total ' num2str(sprintf('%.2f',M_ages)) ]; 
fprintf(FILE_IN, '%s\n', temp); 
temp=['StdDev Age: Total ' num2str(sprintf('%.2f',std_ages)) ];
fprintf(FILE_IN, '%s\n', temp); 
temp=['Age Range: Total ' range_ages ];
fprintf(FILE_IN, '%s\n', temp); 

%print the % of people who have used 
indx=find(ages>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total)*100; 
fprintf(FILE_IN, '%s\n', '% of people who have used POs nonmedically');  
temp=['Total ' num2str(sprintf('%.1f',p))]; 
fprintf(FILE_IN, '%s\n\n', temp); 


%2: # people who have used heroin in their lifetimes 
%Benchmark_Note1/Benchmark_22
%How old were you when you first used heroin? 
heroin_age='Benchmark_Note1/Benchmark_22';
indx=find(strcmp(headers,heroin_age)==1); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 

data_mat(data_mat==0)=NaN; 
data_mat(data_mat==77)=NaN;
data_mat(data_mat==88)=NaN;
data_mat(data_mat==99)=NaN;

heroin_ages=data_mat; 
M_ages=nanmean(heroin_ages); 
std_ages=nanstd(heroin_ages); 
min_age=min(heroin_ages); 
max_age=max(heroin_ages); 

range_ages=[num2str(sprintf('%.2f', min_age)) '-' num2str(sprintf('%.2f',max_age))]; 

fprintf(FILE_IN, '%s\n', 'Age of heroin initiation'); 
temp=['Mean Age: Total ' num2str(sprintf('%.2f',M_ages)) ]; 
fprintf(FILE_IN, '%s\n', temp); 
temp=['StdDev Age: Total ' num2str(sprintf('%.2f',std_ages)) ];
fprintf(FILE_IN, '%s\n', temp); 
temp=['Age Range: Total ' range_ages ];
fprintf(FILE_IN, '%s\n', temp); 

indx=find(heroin_ages>0); 
count=numel(indx); 
total=numel(data_mat); 
p=(count/total)*100; 

fprintf(FILE_IN, '%s\n', '% of people who have used Heroin');  
temp=['Total ' num2str(sprintf('%.1f',p)) ]; 
fprintf(FILE_IN, '%s\n\n', temp); 
%use as denomintaros below
total_=count; 

%stats on the difference between heroin and PO ages 
[h,p]=ttest2(ages, heroin_ages); 
temp=['ttest pvalue between age of initiating PO and initiating heroin ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp); 

%3: percent whom nonmedial PO use preceded heroin use 
%Benchmark_Note1/Benchmark_22-Benchmark_Note1/Benchmark_13
%if positive then YES
diff=heroin_ages-ages; 
indx=find(diff>0 & heroin_ages>0 & ages>0); 
count=numel(indx); 
p=(count/total_)*100; 
fprintf(FILE_IN, '%s\n', '% of people for whom nonmedical PO use preceded heroin use');  
temp=['Total ' num2str(sprintf('%.1f',p))]; 
fprintf(FILE_IN, '%s\n', temp); 

%4: percent for whom heroin use preceded nonmedical PO use
%same as 3 but if negative then YES
indx=find(diff<0 & heroin_ages>0 & ages>0); 
count=numel(indx); 
p=(count/total_)*100; 
fprintf(FILE_IN, '%s\n', '% of people for whom nonmedical heroin use preceded PO use');  
temp=['Total ' num2str(sprintf('%.1f',p))]; 
fprintf(FILE_IN, '%s\n', temp); 

%5: percent who first used POs nonmedically and heroin in the same year
%same as 3 but if 0 then YES
indx=find(diff==0 & heroin_ages>0 & ages>0); 
count=numel(indx); 
p=(count/total_)*100; 
fprintf(FILE_IN, '%s\n', '% of people who first used nonmedical PO use and heroin use in the same year');  
temp=['Total ' num2str(sprintf('%.1f',p))]; 
fprintf(FILE_IN, '%s\n', temp); 


%age of initiating drug injection
first_inj='FirstInj_Note1/FirstInj_2'; 
indx=find(strcmp(headers,first_inj)==1); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
data_mat(data_mat==0)=NaN; 
data_mat(data_mat==77)=NaN;
data_mat(data_mat==88)=NaN;
data_mat(data_mat==99)=NaN; 

inj_age=data_mat;  
M_ages=nanmean(inj_age); 
std_ages=nanstd(inj_age); 
min_age=min(inj_age); 
max_age=max(inj_age); 

range_ages=[num2str(sprintf('%.2f', min_age)) '-' num2str(sprintf('%.2f',max_age))]; 

fprintf(FILE_IN, '%s\n', 'Age of first injection'); 
temp=['Mean Age: Total ' num2str(sprintf('%.2f',M_ages)) ]; 
fprintf(FILE_IN, '%s\n', temp); 
temp=['StdDev Age: Total ' num2str(sprintf('%.2f',std_ages)) ];
fprintf(FILE_IN, '%s\n', temp); 
temp=['Age Range: Total ' range_ages ];
fprintf(FILE_IN, '%s\n\n', temp); 

%hcv and hiv------------------------------------------------------------
hcv='hiv_hcv: hepatitis C Test Results'; 
indx=find(strcmp(headers,hcv)==1); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
data_mat(data_mat==77)=NaN;
data_mat(data_mat==88)=NaN;
data_mat(data_mat==99)=NaN;
indx_hcv=find(data_mat>0); 

total=numel(data_mat); 
p=numel(indx_hcv)/total*100; 
temp=['% who are HCV+ ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n', temp); 


hiv='hiv_hcv: HIV Rapid Test Results '; 
indx=find(strcmp(headers,hiv)==1); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
data_mat(data_mat==77)=NaN;
data_mat(data_mat==88)=NaN;
data_mat(data_mat==99)=NaN;
indx_hiv=find(data_mat>0);

total=numel(data_mat); 
p=numel(indx_hiv)/total*100; 
temp=['% who are HIV+ ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n\n', temp); 

%Injection Risk 
% InjBehavior_6
% In the past 12 months, how many different people did you give your used syringe for them to use?
fprintf(FILE_IN, '%s\n', 'Injection Risk'); 
D='InjBehavior_Note1/InjBehavior_1_group/InjBehavior_6'; 
indx=find(strcmp(headers,D)==1); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat{2,1}=0; 
data_mat=cell2mat(data_mat); 
indx1=find(data_mat>0 & data_mat<3); 
indx3=find(data_mat>2); 

p=numel(indx1)/total*100; 
temp=['% who distributed used syringes to 1-2 people in the past year ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n', temp); 

p=numel(indx3)/total*100; 
temp=['% who distributed used syringes to 3 or more people in the past year ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n\n', temp); 

% InjBehavior_7
% In the past 12 months, from how many people did you receive a syringe that they had previously used?
D='InjBehavior_Note1/InjBehavior_1_group/InjBehavior_7'; 
indx=find(strcmp(headers,D)==1); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx1=find(data_mat>0 & data_mat<3); 
indx3=find(data_mat>2); 

p=numel(indx1)/total*100;  
temp=['% who recieved a syringe 1-2 times that was previously used in the past year ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n', temp); 

p=numel(indx3)/total*100;  
temp=['% who recieved a syringe 3 or more times that was previously used in the past year ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n\n', temp); 

% InjBehavior_8
% In the past 12 months, how many times did you use a syringe that had already been used by somebody else?  
D='InjBehavior_Note1/InjBehavior_1_group/InjBehavior_8'; 
indx=find(strcmp(headers,D)==1); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx1=find(data_mat>0 & data_mat<3); 
indx3=find(data_mat>2); 

p=numel(indx1)/total*100;  
temp=['% who used a syring that was already used by somebody else 1-2 times in the past year ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n', temp); 

p=numel(indx3)/total*100;  
temp=['% who used a syring that was already used by somebody else 3 or more times in the past year  ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n\n', temp); 

% InjBehavior_9
% In the past 12 months, with how many different people did you share cookers?  
D='InjBehavior_Note1/InjBehavior_1_group/InjBehavior_9'; 
indx=find(strcmp(headers,D)==1); 
data_mat=INJECTORS(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx0=find(data_mat==0); 
indx1=find(data_mat>0 & data_mat<3); 
indx3=find(data_mat>2); 

p=numel(indx0)/total*100; 
temp=['% who did not share cookers in the past year ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n', temp);

p=numel(indx1)/total*100; 
temp=['% who shared cookers with 1-2 people in the past year ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n', temp); 

p=numel(indx3)/total*100;  
temp=['% who shared cookers with 3 or more people in the past year ' num2str(sprintf('%.1f',p)) '%']; 
fprintf(FILE_IN, '%s\n\n', temp); 

new_ques={'Soc_Note1/Soc_11', 'Soc_Note1/Soc_13', 'Overdose_8','Overdose_1_group/Overdose_10'}; 
new_label={'Ever homeless', 'Currently homeless', 'Ever overdosed', 'Mean number of times overdosed (for those who have overdosed)'}; 


for i=1:numel(new_ques)
    D=new_ques{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=INJECTORS(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat=cell2mat(data_mat); 
    
    data_mat2=filtered_data(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat2)==1); 
    for j=1:numel(indx_nan)
        data_mat2{indx_nan(j)}=NaN; 
    end 
    data_mat2=cell2mat(data_mat2); 
    
    if i<4
        indx1=find(data_mat==1); 
        if i~=2
            total=find(isnan(data_mat)==0);  %use old total for the i=2 
        end 
        p=numel(indx1)/numel(total)*100; 
        temp=[new_label{i} ' (Injectors): N = ' num2str(numel(indx1)) ' (' num2str(sprintf('%.1f',p)) '%)']; 
        fprintf(FILE_IN, '%s\n', temp); 
         
        %all data
        indx2=find(data_mat2==1); 
        if i~=2
            total2=find(isnan(data_mat2)==0);  %use old total for the i=2 
        end 
        p=numel(indx2)/numel(total2)*100; 
        temp=[new_label{i} '(ALL): N = ' num2str(numel(indx2)) ' (' num2str(sprintf('%.1f',p)) '%)']; 
        fprintf(FILE_IN, '%s\n\n', temp); 
    else 
        new_data=data_mat(indx1); 
        m=mean(new_data); 
        s=std(new_data); 
        temp=[new_label{i} '(Injectors): Mean = ' num2str(sprintf('%.1f',m)) ' stdev = ' num2str(sprintf('%.1f',s))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        
        % ALL data  
        new_data2=data_mat2(indx2); 
        m=mean(new_data2); 
        s=std(new_data2); 
        temp=[new_label{i} ' (ALL): Mean = ' num2str(sprintf('%.1f',m)) ' stdev = ' num2str(sprintf('%.1f',s))]; 
        fprintf(FILE_IN, '%s\n\n', temp); 
    end 
end


fclose(FILE_IN); 

know_seed='KeyNet_Note1/KeyNet_1'; 

indx=find(strcmp(headers,know_seed)==1); 
data_mat=filtered_data(:,indx); 
know=zeros(11,1); 
for i=1:numel(data_mat)
    x=data_mat{i}; 
    indx=strfind(x,' '); 
    if isempty(indx)==1
        n=str2double(data_mat{i}); 
        if n>0 && n<12
            know(n)=know(n)+1; 
        else
            n
        end 
    else 
        count=1; 
        for j=1:numel(indx)
            n=''; 
            for b=count:indx(j)-1
                d=x(b); 
                n=[n d]; 
            end 
            n_=str2double(n); 
            if n_>0 && n_<12
                know(n_)=know(n_)+1; 
            else
                n_
            end 
            count=indx(j)+1; 
        end 
        %do the last one! 
        n=''; 
        for b=count:numel(x); 
            d=x(b); 
            n=[n d]; 
        end 
        n_=str2double(n); 
        if n_>0 && n_<12
            know(n_)=know(n_)+1; 
        else
            n_
        end 
    end 
end 

total=numel(data_mat); 

know_per=know/total*100; 
