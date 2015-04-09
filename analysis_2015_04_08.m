cd matrices
load filtered_db_2015_02_24
load AGES 
cd ..

FILE_IN=fopen('results_2015_04_08.txt', 'wt'); 
%1. DEMOGRAPHICS
demograph={'Soc_Note1/Soc_3','Soc_Note1/Soc_4', 'Soc_Note1/Soc_5', 'Soc_Note1/Soc_6','Soc_Note1/Soc_10',...
    'Soc_Note1/Soc_13', 'Soc_Note1/Soc_19', 'Soc_Note1/Soc_22', 'Soc_Note1/Soc_32', 'Soc_Note1/Soc_34'};

labels={'Age', 'Hispanic', 'Race', 'Borough', 'Sex', 'Currently Homeless', 'Highest education', 'Socioeconomic class',...
    'Health Insurance stauts','Seen a doctor in past 12 months' }; 

education={'Did not complete high school', 'High school graduate or GED', 'Some college/Associates degree', 'College graduate or more','NA'}; 
race={'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian/Pacific Islander', 'White', 'Multiracial'}; 
soc_class={'Affluent', 'Upper Middle Class', 'Middle Class', 'Lower Middle Class', 'Poor'}; 
soc_23={'$0-$25,000', '$26,000-$50,000', '$51,000-$75,000', '$76,000-$100,000', '$101,000-$125,000', '$126,000-$150,000', '$151,000-$200,000', '$201,000-$250,000', '$251+'}; 
borough={'Manhattan', 'Staten Island', 'Brooklyn', 'Bronx', 'Queens'};

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
    
    %GENDER
    if (strcmp(labels{i},'Sex')==1) %gender M=1, F=2, transgender=3,4
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
       
    elseif (strcmp(labels{i},'Age')==1) %DATE OF BIRTH
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
        std_ages=nanstd(ages); 
        min_age=min(ages); 
        max_age=max(ages); 
        range_ages=[num2str(sprintf('%.2f', min_age)) '-' num2str(sprintf('%.2f',max_age))]; 
        
        fprintf(FILE_IN, '%s\n', 'Age'); 
        temp=['Mean Age: ' num2str(sprintf('%.2f',M_ages))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['StdDev Age: ' num2str(sprintf('%.2f',std_ages))];
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Age Range: ' range_ages];
        fprintf(FILE_IN, '%s\n\n', temp); 
        
    elseif (strcmp(labels{i},'Race')==1) %RACE
        race_mat=double.empty; %number race, % race, number male, %race male, number female, %race female
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
            
            temp=['Number of ' race{j} ': ' num2str(race_mat(j,1))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' race{j} ':  ' num2str(sprintf('%.1f',race_mat(j,2))) '%']; 
            fprintf(FILE_IN, '%s\n', temp);   
        end 
        indx_missing=find(data_mat>6 | isnan(data_mat)==1); 
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        temp=['Number of missing: ' num2str(n) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: ' num2str(sprintf('%.1f',n_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        RACE=data_mat; 
        fprintf(FILE_IN, '\n'); 
    elseif (strcmp(labels{i},'Hispanic')==1)
        %ETHNICITY (hispanic or nonhispanic)
        data_mat=cell2mat(data_mat); 
        indx_his=find(data_mat==1); 
        indx_total=find(data_mat==0 | data_mat==1); 
        per_total=numel(indx_his)/numel(data_mat)*100; 
        
        fprintf(FILE_IN, '%s\n', 'Hispanic/Latino'); 
        temp=['Number of Hispanic/Latino: ' num2str(numel(indx_his))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent of Hispanic/Latino: ' num2str(sprintf('%.1f',per_total)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        
        indx_missing=find(data_mat>1 | isnan(data_mat)==1);  
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/numel(data_mat)*100; 
        temp=['Number of missing: ' num2str(n)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: ' num2str(sprintf('%.1f',n_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        fprintf(FILE_IN, '\n'); 
        HISPANIC=data_mat; 

    elseif (strcmp(labels{i},'Highest Education')==1) %highest level of education
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
            
            temp=[education{j} ': ' num2str(race_mat(j,1))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' education{j} ': ' num2str(sprintf('%.1f',race_mat(j,2))) '%']; 
            fprintf(FILE_IN, '%s\n', temp);   
            
            s=s+race_mat(j,2); 
        end 
        indx_missing=find(data_mat>6 | isnan(data_mat)==1);  
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        temp=['Number of missing: ' num2str(n) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: ' num2str(sprintf('%.1f',n_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        EDUCATION=data_mat; 
        fprintf(FILE_IN, '\n'); 
        
    elseif (strcmp(labels{i},'Socioeconomic class')==1)
        data_mat=cell2mat(data_mat); 
        indx_total=find(data_mat>0 & data_mat<6); 
        total_num=numel(data_mat); 
        fprintf(FILE_IN, '%s\n', 'Socioeconomic Class'); 
        s=0; 
        for j=1:5
            indx_race=find (data_mat==j); 
            race_mat(j,1)=numel(indx_race); 
            race_mat(j,2)=numel(indx_race)/total_num*100; 
            
            temp=[soc_class{j} ': ' num2str(race_mat(j,1))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent ' soc_class{j} ': ' num2str(sprintf('%.1f',race_mat(j,2))) '%']; 
            fprintf(FILE_IN, '%s\n', temp);   
            
            s=s+race_mat(j,2); 
        end 
            
        indx_missing=find(data_mat>5 | isnan(data_mat)==1); 
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        temp=['Number of missing: ' num2str(n) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: ' num2str(sprintf('%.1f',n_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        CLASS=data_mat; 
        fprintf(FILE_IN, '\n'); 
        
    elseif (strcmp(labels{i},'Currently homeless')==1)
        
        data_mat=cell2mat(data_mat); 
        indx_his=find(data_mat==1); 
        indx_total=find(data_mat==0 | data_mat==1); 
        per_total=numel(indx_his)/numel(data_mat)*100; 
        
        fprintf(FILE_IN, '%s\n', 'Currently Homeless'); 
        temp=['Currently homeless ' num2str(numel(indx_his))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent currently homeless:  ' num2str(sprintf('%.1f',per_total)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        
        indx_missing=find(data_mat>1 | isnan(data_mat)==1);  
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/numel(data_mat)*100; 
        temp=['Number of missing: ' num2str(n)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: ' num2str(sprintf('%.1f',n_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        fprintf(FILE_IN, '\n'); 
        
    elseif (strcmp(labels{i}, 'Borough')==1)
        data_mat=cell2mat(data_mat); 
        total_num=numel(data_mat); 
        fprintf(FILE_IN, '%s\n', 'Borough'); 
        s=0; 
        for j=1:5
            indx_race=find (data_mat==j); 
            race_mat(j,1)=numel(indx_race); 
            race_mat(j,2)=numel(indx_race)/total_num*100; 
            
            temp=['Number living in ' borough{j} ': ' num2str(race_mat(j,1))]; 
            fprintf(FILE_IN, '%s\n', temp);   
            temp=['Percent living in ' borough{j} ':  ' num2str(sprintf('%.1f',race_mat(j,2))) '%']; 
            fprintf(FILE_IN, '%s\n', temp);   
        end 
        indx_missing=find(data_mat>5 | isnan(data_mat)==1); 
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/total_num*100; 
        temp=['Number of missing: ' num2str(n) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: ' num2str(sprintf('%.1f',n_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        fprintf(FILE_IN, '\n'); 
        
    elseif (strcmp(labels{i}, 'Health Insurance stauts')==1)
        data_mat=cell2mat(data_mat); 
        indx_his=find(data_mat==1); 
        indx_total=find(data_mat==0 | data_mat==1); 
        per_total=numel(indx_his)/numel(data_mat)*100; 
        
        fprintf(FILE_IN, '%s\n', 'Health Insurance Status'); 
        temp=['Currently has health insurance ' num2str(numel(indx_his))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent currently has health insurance:  ' num2str(sprintf('%.1f',per_total)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        
        indx_missing=find(data_mat>1 | isnan(data_mat)==1);  
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/numel(data_mat)*100; 
        temp=['Number of missing: ' num2str(n)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: ' num2str(sprintf('%.1f',n_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        fprintf(FILE_IN, '\n');
        
    elseif (strcmp(labels{i}, 'Seen a doctor in past 12 months')==1)
        data_mat=cell2mat(data_mat); 
        indx_his=find(data_mat==1); 
        indx_total=find(data_mat==0 | data_mat==1); 
        per_total=numel(indx_his)/numel(data_mat)*100; 
        
        fprintf(FILE_IN, '%s\n', 'Seen a doctor in past 12 months'); 
        temp=['Has seen a doctor in past 12 months ' num2str(numel(indx_his))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent that have seen a doctor in past 12 months:  ' num2str(sprintf('%.1f',per_total)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        
        indx_missing=find(data_mat>1 | isnan(data_mat)==1);  
        n=numel(indx_missing); 
        n_p=numel(indx_missing)/numel(data_mat)*100; 
        temp=['Number of missing: ' num2str(n)]; 
        fprintf(FILE_IN, '%s\n', temp); 
        temp=['Percent missing: ' num2str(sprintf('%.1f',n_p)) '%']; 
        fprintf(FILE_IN, '%s\n', temp); 
        fprintf(FILE_IN, '\n');

    end 
end 


%%cross table for race and hispanic 
cross_tab=cell.empty; 
cross_tab{1,1}='Race'; 
cross_tab{1,2}='Hispanic'; 
cross_tab{1,3}='Non-hispanic'; 
for i=1:6
    cross_tab{i+1,1}=race{i}; 
    indx_race=find(RACE==i); 
    indx_yes=find(HISPANIC==1); 
    indx_no=find(HISPANIC==0); 
    n=numel(intersect(indx_race, indx_yes));
    m=numel(intersect(indx_race, indx_no)); 
    t=numel(indx_race); 
    N=n/t*100; 
    M=m/t*100; 
    n_=num2str(sprintf('%.1f',N)); 
    m_=num2str(sprintf('%.1f',M)); 
    cross_tab{i+1, 2}=[n_ '%']; 
    cross_tab{i+1, 3}=[m_ '%']; 
    cross_tab{i+1, 4}=t; 
end 

fclose(FILE_IN); 
