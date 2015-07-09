load filtered_final_2015_05_06
FILE_IN=fopen('demographics.txt', 'wt'); 
%1. DEMOGRAPHICS
demograph={'Soc_Note1/Soc_10', 'Soc_Note1/Soc_3', 'Soc_Note1/Soc_5','Soc_Note1/Soc_4','Soc_Note1/Soc_19', 'Soc_Note1/Soc_22', 'Soc_Note1/Soc_23'};
%in order of header Gender, Age (DOB), Race, Ethnicity, Highest level of
%education

%find the frequency/percentage for all but the age, find mean, range and
%std
education={'Did not complete high school', 'High school graduate or GED', 'Some college/Associates degree', 'College graduate or more','NA'}; 
race={'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian/Pacific Islander', 'White', 'Multiracial'}; 
soc_class={'Affluent', 'Upper Middle Class', 'Middle Class', 'Lower Middle Class', 'Poor'}; 
soc_23={'$0-$25,000', '$26,000-$50,000', '$51,000-$75,000', '$76,000-$100,000', '$101,000-$125,000', '$126,000-$150,000', '$151,000-$200,000', '$201,000-$250,000', '$251+'}; 

[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 
for i=1:numel(demograph)
    D=demograph{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
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
            
            temp=['Number of ' race{j} ': Total ' num2str(race_mat(j,1)) ', Male ' num2str(race_mat(j,3)) ', Female ' num2str(race_mat(j,5))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' race{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2))) '%, Male ' num2str(sprintf('%.1f',race_mat(j,4))) '%, Female ' num2str(sprintf('%.1f',race_mat(j,6))) '%']; 
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
        temp=['Number of missing: Total ' num2str(n) ', Male ' num2str(m) ', Female ' num2str(f)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p)) '%, Male ' num2str(sprintf('%.1f',m_p)) '%, Female ' num2str(sprintf('%.1f',f_p)) '%']; 
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
        temp=['Number of Hispanic/Latino: Total ' num2str(numel(indx_his)), ', Male ' num2str(numel(male)) ',  Female ' num2str(numel(female))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent of Hispanic/Latino: Total ' num2str(sprintf('%.1f',per_total)), '%, Male ' num2str(sprintf('%.1f',per_male)) '%,  Female ' num2str(sprintf('%.1f',per_female)) '%']; 
        fprintf(FILE_IN, '%s\n\n', temp); 
        
        indx_missing=find(data_mat>1 | isnan(data_mat)==1);  
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/numel(data_mat)*100; 
        male=intersect(indx_missing, indx_male); 
        m=numel(male); 
        m_p=numel(male)/numel(indx_male)*100; 
        female=intersect(indx_missing, indx_female); 
        f=numel(female); 
        f_p=numel(female)/numel(indx_female)*100; 
        temp=['Number of missing: Total ' num2str(n) ', Male ' num2str(m) ', Female ' num2str(f)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p)) '%, Male ' num2str(sprintf('%.1f',m_p)) '%, Female ' num2str(sprintf('%.1f',f_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        fprintf(FILE_IN, '\n'); 
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
            
            temp=[education{j} ': Total ' num2str(race_mat(j,1)) ', Male ' num2str(race_mat(j,3)) ', Female ' num2str(race_mat(j,5))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' education{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2))) '%, Male ' num2str(sprintf('%.1f',race_mat(j,4))) '%, Female ' num2str(sprintf('%.1f',race_mat(j,6))) '%']; 
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
        temp=['Number of missing: Total ' num2str(n) ', Male ' num2str(m) ', Female ' num2str(f)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p)) '%, Male ' num2str(sprintf('%.1f',m_p)) '%, Female ' num2str(sprintf('%.1f',f_p)) '%']; 
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
            
            temp=[soc_class{j} ': Total ' num2str(race_mat(j,1)) ', Male ' num2str(race_mat(j,3)) ', Female ' num2str(race_mat(j,5))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' soc_class{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2))) '%, Male ' num2str(sprintf('%.1f',race_mat(j,4))) '%, Female ' num2str(sprintf('%.1f',race_mat(j,6))) '%']; 
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
        temp=['Number of missing: Total ' num2str(n) ', Male ' num2str(m) ', Female ' num2str(f)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p)) '%, Male ' num2str(sprintf('%.1f',m_p)) '%, Female ' num2str(sprintf('%.1f',f_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        CLASS=data_mat; 
        fprintf(FILE_IN, '\n'); 
        s6=s+n_p 
        % Soc_22
        % While you were growing up, what would you say your socioeconomic class was?
        % 1	Affluent 
        % 2	Upper Middle Class 
        % 3	Middle Class 
        % 4	Lower Middle Class 
        % 5	Poor 
        % 77	Not Applicable 
        % 88	Don't Know
        % 99	Refused To Answer 
    elseif i==7
        data_mat=cell2mat(data_mat); 
        indx_total=find(data_mat>0 & data_mat<10); 
        total_num=numel(data_mat); 
        indx_f=intersect(indx_total, indx_female); 
        indx_m=intersect(indx_total, indx_male); 
        fprintf(FILE_IN, '%s\n', 'Household Income'); 
        s=0; 
        for j=1:9
            indx_race=find (data_mat==j); 
            race_mat(j,1)=numel(indx_race); 
            race_mat(j,2)=numel(indx_race)/total_num*100; 
            male=intersect(indx_race,indx_male); 
            race_mat(j,3)=numel(male); 
            race_mat(j,4)=numel(male)/numel(indx_male)*100; 
            female=intersect(indx_race,indx_female); 
            race_mat(j,5)=numel(female); 
            race_mat(j,6)=numel(female)/numel(indx_female)*100; 
            
            temp=[soc_23{j} ': Total ' num2str(race_mat(j,1)) ', Male ' num2str(race_mat(j,3)) ', Female ' num2str(race_mat(j,5))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' soc_23{j} ': Total ' num2str(sprintf('%.1f',race_mat(j,2))) '%, Male ' num2str(sprintf('%.1f',race_mat(j,4))) '%, Female ' num2str(sprintf('%.1f',race_mat(j,6))) '%']; 
            fprintf(FILE_IN, '%s\n', temp);   
            
            s=s+race_mat(j,2); 
        end 
            
        indx_missing=find(data_mat>9 | isnan(data_mat)==1); 
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        male=intersect(indx_missing, indx_male); 
        m=numel(male); 
        m_p=numel(male)/numel(indx_male)*100; 
        female=intersect(indx_missing, indx_female); 
        f=numel(female); 
        f_p=numel(female)/numel(indx_female)*100; 
        temp=['Number of missing: Total ' num2str(n) ', Male ' num2str(m) ', Female ' num2str(f)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: Total ' num2str(sprintf('%.1f',n_p)) '%, Male ' num2str(sprintf('%.1f',m_p)) '%, Female ' num2str(sprintf('%.1f',f_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        INCOME=data_mat; 
        fprintf(FILE_IN, '\n'); 
        s7=s+n_p 
        % Soc_23
        % What was your estimated household income growing up?
        % 1	$0-$25,000
        % 2	$26,000-$50,000
        % 3	$51,000-$75,000
        % 4	$76,000-$100,000
        % 5	$101,000-$125,000
        % 6	$126,000-$150,000
        % 7	$151,000-$200,000
        % 8	$201,000-$250,000
        % 9	$251,000+
        % 77	Not Applicable 
        % 88	Don't Know 
        % 99	Refused to Answer 
    end 
end 
fclose(FILE_IN); 

save('RACE.mat','RACE'); 
save('GENDER.mat','GENDER'); 
save('AGES.mat','AGES');
save('EDUCATION.mat','EDUCATION'); 
save ('CLASS.mat', 'CLASS'); 
save('INCOME.mat', 'INCOME'); 






