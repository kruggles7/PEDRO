load filtered_db_2015_01_18
FILE_IN=fopen('demographics.txt', 'wt'); 
%1. DEMOGRAPHICS
demograph={'Soc_Note1/Soc_10', 'Soc_Note1/Soc_3', 'Soc_Note1/Soc_5','Soc_Note1/Soc_4','Soc_Note1/Soc_19'};
%in order of header Gender, Age (DOB), Race, Ethnicity, Highest level of
%education

%find the frequency/percentage for all but the age, find mean, range and
%std
education={'Did not complete high school', 'High school graduate or GED', 'Some college/Associates degree', 'College graduate',...
    'Some graduate school', 'Graduate/professional degree', 'NA'}; 
race={'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian/Pacific Islander', 'White', 'Multiracial'}; 
[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 
for i=1:numel(demograph)
    D=demograph{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
    
    if (i==1) %gender M=1, F=2, transgender=3,4
        data_mat=str2double(data_mat); 
        indx_male=find(data_mat==1); 
        indx_female=find(data_mat==2); 
        indx_total=find(data_mat>0 & data_mat<5); 
        per_male=numel(indx_male)/numel(indx_total)*100; 
        fprintf(FILE_IN, '%s\n', 'Gender'); 
        per_female=numel(indx_female)/numel(indx_total)*100; 
        temp=['Number of Males: ' num2str(numel(indx_male))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent of Males: ' num2str(sprintf('%.1f', per_male)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Number of Females: ' num2str(numel(indx_female))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent of Females: ' num2str(sprintf('%.1f',per_female)) '%']; 
        fprintf(FILE_IN, '%s\n\n', temp); 
        GENDER=data_mat; %to use in the rest of the analysis
        
    elseif (i==2) %DATE OF BIRTH
        today='Soc_Note1/Soc_1'; 
        indx_today=find(strcmp(headers,today)==1); 
        today_mat=filtered_data(:,indx_today); 
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
            numdays=datenum(TODAY)-datenum(BIRTH); 
            numyears=numdays/365; 
            ages(j)=numyears; 
        end 
        AGES=ages; 
        
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
        
    elseif (i==3) %RACE
        race_mat=double.empty; %number race, % race, number male, %race male, number female, %race female
        data_mat=str2double(data_mat); 
        indx_total=find(data_mat>0 & data_mat<7); 
        total_num=numel(indx_total); 
        indx_f=intersect(indx_total, indx_female); 
        indx_m=intersect(indx_total, indx_male); 
        fprintf(FILE_IN, '%s\n', 'Race'); 
        for j=1:6
            indx_race=find (data_mat==j); 
            race_mat(j,1)=numel(indx_race); 
            race_mat(j,2)=numel(indx_race)/total_num*100; 
            male=intersect(indx_race,indx_male); 
            race_mat(j,3)=numel(male); 
            race_mat(j,4)=numel(male)/numel(indx_m)*100; 
            female=intersect(indx_race,indx_female); 
            race_mat(j,5)=numel(female); 
            race_mat(j,6)=numel(female)/numel(indx_f)*100; 
            
            temp=['Number of ' race{j} ': Total ' num2str(race_mat(j,1)) ', Male ' num2str(race_mat(j,3)) ', Female ' num2str(race_mat(j,5))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' race{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2))) '%, Male ' num2str(sprintf('%.1f',race_mat(j,4))) '%, Female ' num2str(sprintf('%.1f',race_mat(j,6))) '%']; 
            fprintf(FILE_IN, '%s\n', temp);   
        end 
        RACE=data_mat; 
        fprintf(FILE_IN, '\n'); 
        
    elseif (i==4)
        %ETHNICITY (hispanic or nonhispanic)
        data_mat=str2double(data_mat); 
        indx_his=find(data_mat==1); 
        male=intersect(indx_his,indx_male); 
        female=intersect(indx_his,indx_female); 
        
        indx_total=find(data_mat==0 | data_mat==1); 
        indx_f=intersect(indx_total, indx_female); 
        indx_m=intersect(indx_total, indx_male); 
        
        per_total=numel(indx_his)/numel(indx_total)*100; 
        per_male=numel(male)/numel(indx_m)*100; 
        per_female=numel(female)/numel(indx_f)*100; 
        
        fprintf(FILE_IN, '%s\n', 'Hispanic/Latino'); 
        temp=['Number of Hispanic/Latino: Total ' num2str(numel(indx_his)), ', Male ' num2str(numel(male)) ',  Female ' num2str(numel(female))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent of Hispanic/Latino: Total ' num2str(sprintf('%.1f',per_total)), '%, Male ' num2str(sprintf('%.1f',per_male)) '%,  Female ' num2str(sprintf('%.1f',per_female)) '%']; 
        fprintf(FILE_IN, '%s\n\n', temp); 
        
    elseif (i==5) %highest level of education
        data_mat=str2double(data_mat); 
        indx_total=find(data_mat>0 & data_mat<5); 
        total_num=numel(indx_total); 
        indx_f=intersect(indx_total, indx_female); 
        indx_m=intersect(indx_total, indx_male); 
        fprintf(FILE_IN, '%s\n', 'Education level'); 
        for j=1:7
            indx_race=find (data_mat==j); 
            race_mat(j,1)=numel(indx_race); 
            race_mat(j,2)=numel(indx_race)/total_num*100; 
            male=intersect(indx_race,indx_male); 
            race_mat(j,3)=numel(male); 
            race_mat(j,4)=numel(male)/numel(indx_m)*100; 
            female=intersect(indx_race,indx_female); 
            race_mat(j,5)=numel(female); 
            race_mat(j,6)=numel(female)/numel(indx_f)*100; 
            
            temp=[education{j} ': Total ' num2str(race_mat(j,1)) ', Male ' num2str(race_mat(j,3)) ', Female ' num2str(race_mat(j,5))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' education{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2))) '%, Male ' num2str(sprintf('%.1f',race_mat(j,4))) '%, Female ' num2str(sprintf('%.1f',race_mat(j,6))) '%']; 
            fprintf(FILE_IN, '%s\n', temp);   
        end 
        EDUCATION=data_mat; 
        fprintf(FILE_IN, '\n'); 
        
    end 
end 
fclose(FILE_IN); 

save('RACE.mat','RACE'); 
save('GENDER.mat','GENDER'); 
save('AGES.mat','AGES');
save('EDUCATION.mat','EDUCATION'); 
