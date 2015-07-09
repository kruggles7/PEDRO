%Find total ACD score per subject

load filtered_final_2015_05_06

variables={'childhood_Note1/Childhood_1','childhood_Note1/Childhood_3','childhood_Note1/Childhood_5','childhood_Note1/Childhood_7','childhood_Note1/Childhood_9',...
    'childhood_Note1/Childhood_11','childhood_Note1/Childhood_13','childhood_Note1/Childhood_15','childhood_Note1/Childhood_17','childhood_Note1/Childhood_19'};

variables_age={'childhood_Note1/Childhood_2','childhood_Note1/Childhood_4','childhood_Note1/Childhood_6','childhood_Note1/Childhood_8','childhood_Note1/Childhood_10',...
    'childhood_Note1/Childhood_12','childhood_Note1/Childhood_14','childhood_Note1/Childhood_16','childhood_Note1/Childhood_18','childhood_Note1/Childhood_20'};

variables_lab={'parent/adult swore, humiliated or made afraid of being physically hurt', 'parent/adult pushed, slapped or threw something at',...
    'parent/adult fondled or touched in a sexual way or had intercourse with', 'felt as if no one in the family loved or supported them',...
    'often felt that they did not have enough to eat, was not protected', 'parents separated/divorced', 'mother/stepmother physically abused',...
    'lived with someone who had drug/drinking problem', 'household member depressed/mentally ill', 'household member went to prison'}; 


questions={'Benchmark_Note1/Benchmark_1', 'Benchmark_Note1/Benchmark_2', 'Benchmark_Note1/Benchmark_3', 'Benchmark_Note1/Benchmark_4',...
    'Benchmark_Note1/Benchmark_5','Benchmark_Note1/Benchmark_6', 'Benchmark_Note1/Benchmark_13', 'Benchmark_Note1/Benchmark_14',...
    'Benchmark_Note1/Benchmark_17', 'Benchmark_Note1/Benchmark_18', 'Benchmark_Note1/Benchmark_19', 'Benchmark_Note1/Benchmark_20', 'Benchmark_Note1/Benchmark_22', ...
    'Benchmark_Note1/Benchmark_24', 'Benchmark_Note1/Benchmark_25', 'Benchmark_Note1/Benchmark_28', 'Benchmark_Note1/Benchmark_31'  }; 

quest_labels={'first got drunk', 'started drinking on regular basis', 'first tried marijuana', 'started using marijuana on a regular basis',...
    'first had sexual intercourse', 'first had sexual intercourse on a regular basis', 'first started using POs', 'first started using POs regularly',...
    'first snorted POs', 'first smoked POs', 'first injected any drug', 'first injected POs', 'first used heroin',...
    'first injected heroin', 'first started using heroin regularly', 'first used benzos', 'first started using benzos regularly'}; 

birthday='Soc_Note1/Soc_3'; 

[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 
plot1=0; 
plot2=0; 


FILE_IN=fopen('ACE.txt', 'wt'); 

%ACE scale
ACE_mat=zeros(r-1,1); 
for i=1:numel(variables)
    D=variables{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat=cell2mat(data_mat); 
    data_mat(data_mat==77)=NaN;
    data_mat(data_mat==88)=NaN;
    data_mat(data_mat==99)=NaN;
    for j=1:numel(data_mat)
        if data_mat(j)==1
            ACE_mat(j)=ACE_mat(j)+1; 
        end 
    end 
    
end 

m=nanmean(ACE_mat); 
s=nanstd(ACE_mat);
new_mat=ACE_mat(isnan(ACE_mat)==0); 
n=numel(new_mat); 
fprintf(FILE_IN, '%s\n', ['ACE results: N = ' num2str(n) ', Mean = ' num2str(m) ', SD = ' num2str(s) ]);
for i=0:10
    indx=find(ACE_mat==i); 
    n=numel(indx); 
    p=n/numel(ACE_mat)*100; 
    fprintf(FILE_IN, '%s\n', ['ACE = ' num2str(i) ' N = ' num2str(n) ' (' num2str(sprintf('%.1f',p)) '%)' ]);
end 
fprintf(FILE_IN, '\n'); 


%%DEMOGRAPHICS----------------------------------------------------------------
%1. DEMOGRAPHICS
demograph={'Soc_Note1/Soc_10', 'Soc_Note1/Soc_3', 'Soc_Note1/Soc_5','Soc_Note1/Soc_4','Soc_Note1/Soc_19', 'Soc_Note1/Soc_22', 'Soc_Note1/Soc_23'};
%in order of header Gender, Age (DOB), Race, Ethnicity, Highest level of
%education

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
        fprintf(FILE_IN, '%s\n', temp); 
        GENDER=data_mat; %to use in the rest of the analysis
        
        max_n=max(numel(indx_male), numel(indx_female)); 
        stat_mat=nan(max_n, 2);  
        stat_mat(1:numel(indx_male),1)=ACE_mat(indx_male); 
        stat_mat(1:numel(indx_female),2)=ACE_mat(indx_female); 
        p=anova1(stat_mat); 
        fprintf(FILE_IN, '%s\n\n', ['ANOVA1 comparing males vs. females p = ' num2str(sprintf('%.3f', p)) ]);
       
         
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
        fprintf(FILE_IN, '%s\n', temp); 
        
        indx_20=find(ages<25); 
        indx_30=find(ages>=25); 
        max_n=max(numel(indx_20), numel(indx_30)); 
        stat_mat=nan(max_n, 2);  
        stat_mat(1:numel(indx_20),1)=ACE_mat(indx_20); 
        stat_mat(1:numel(indx_30),2)=ACE_mat(indx_30); 
        p=100*numel(indx_20)/numel(data_mat); 
        temp=['Participants < 25 N = ' num2str(numel(indx_20)) '(' num2str(sprintf('%.1f', p)) '%)' ];
        fprintf(FILE_IN, '%s\n', temp); 
        p=100*numel(indx_30)/numel(data_mat); 
        temp=['Participants >= 25 N = ' num2str(numel(indx_30)) '(' num2str(sprintf('%.1f', p)) '%)' ];
        fprintf(FILE_IN, '%s\n', temp); 
        p=anova1(stat_mat);  
        fprintf(FILE_IN, '%s\n\n', ['ANOVA1 of ACE scores comparing those <25 and those >=25 p = ' num2str(sprintf('%.3f', p)) ]);
        
       
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
        stat_mat=nan(numel(data_mat),6); 
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
            
            stat_mat(1:numel(indx_race),j)=ACE_mat(indx_race); 
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
       
        p=anova1(stat_mat);  
        fprintf(FILE_IN, '%s\n', ['ANOVA1 of race p = ' num2str(sprintf('%.3f', p)) ]);
        
        if p<0.05
            for j=1:5
                for k=j+1:6
                     [h, p, ci, stats]=ttest2(stat_mat(:,j),stat_mat(:,k));
                     if p<0.05
                        fprintf(FILE_IN, '%s\n', ['ttest comparing ACE scroes in ' race{j} ' vs ' race{k} ' p = ' num2str(sprintf('%.3f', p))]);
                     end 
                end 
            end 
        end
        fprintf(FILE_IN, '\n'); 
        
    elseif (i==4)
        %ETHNICITY (hispanic or nonhispanic)
        stat_mat=nan(numel(data_mat),2); 
        
        data_mat=cell2mat(data_mat); 
        indx_his=find(data_mat==1); 
        indx_non=find(data_mat==0); 
        
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
        
        stat_mat(1:numel(indx_his),1)=ACE_mat(indx_his); 
        stat_mat(1:numel(indx_non),2)=ACE_mat(indx_non); 
        p=anova1(stat_mat);  
        fprintf(FILE_IN, '%s\n\n', ['ANOVA1 of ACE scores in hispanic vs. non-hispanic p = ' num2str(sprintf('%.3f', p)) ]);
        
        
    elseif (i==5) %highest level of education
        data_mat=cell2mat(data_mat); 
        indx_total=find(data_mat>0 & data_mat<8); 
        total_num=numel(data_mat); %%CHANGED THIS 
        indx_f=intersect(indx_total, indx_female); 
        indx_m=intersect(indx_total, indx_male); 
        fprintf(FILE_IN, '%s\n', 'Education level'); 

        stat_mat=nan(numel(data_mat),4); 
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
            
            stat_mat(1:numel(indx_race),j)=ACE_mat(indx_race); 
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
      
        EDUCATION=data_mat; 
        
        p=anova1(stat_mat);  
        fprintf(FILE_IN, '%s\n', ['ANOVA1 of ACE scores by education level p = ' num2str(sprintf('%.3f', p)) ]);
        
        if p<0.05
            for j=1:3
                for k=j+1:4
                     [h, p, ci, stats]=ttest2(stat_mat(:,j),stat_mat(:,k));
                     if p<0.05
                        fprintf(FILE_IN, '%s\n', ['ttest comparing ACE scroes in ' education{j} ' vs ' education{k} ' p = ' num2str(sprintf('%.3f', p)) ]);
                     end
                end 
            end 
        end
        fprintf(FILE_IN, '\n');
        
    elseif (i==6)
        data_mat=cell2mat(data_mat); 
        stat_mat=nan(numel(data_mat),5); 
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
            
            stat_mat(1:numel(indx_race),j)=ACE_mat(indx_race); 
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
        
         p=anova1(stat_mat);  
        fprintf(FILE_IN, '%s\n', ['ANOVA1 of ACE scores by socioeconomic class p = ' num2str(sprintf('%.3f', p)) ]);
        if p<0.05
             for j=1:4
                for k=j+1:5
                     [h, p, ci, stats]=ttest2(stat_mat(:,j),stat_mat(:,k));
                     if p<0.05
                        fprintf(FILE_IN, '%s\n', ['ttest comparing ACE scroes in ' soc_class{j} ' vs ' soc_class{k} ' p = ' num2str( p) ]);
                     end 
                end 
             end 
        end
        fprintf(FILE_IN, '\n');
        
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
        
        stat_mat=nan(numel(data_mat),3); 
        for j=1:3
            if (j==1)
                indx_race=find (data_mat<3); 
            elseif (j==2)
                indx_race=find(data_mat>2 & data_mat<5); 
            else
                indx_race=find(data_mat>4 & data_mat<10); 
            end
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
            
            stat_mat(1:numel(indx_race),j)=ACE_mat(indx_race); 
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
        
         p=anova1(stat_mat);  
        fprintf(FILE_IN, '%s\n', ['ANOVA1 of ACE scores for household income p = ' num2str(sprintf('%.3f', p)) ]);
        
        if p<0.05
             for j=1:2
                for k=j+1:3
                     [h, p, ci, stats]=ttest2(stat_mat(:,j),stat_mat(:,k));
                     if p<0.05
                        fprintf(FILE_IN, '%s\n', ['ttest comparing ACE scroes in ' soc_23{j} ' vs ' soc_23{k} ' p = ' num2str(sprintf('%.3f', p)) ]);
                     end
                end 
             end 
        end 
        fprintf(FILE_IN, '\n');
        
      
    end 
end 
close all

%----------------------------------------------------------------------------------

%%%General information on the 'age of first risk behavior' variables 
for i=1:numel(questions)
    D=questions{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat=cell2mat(data_mat); 
    data_mat(data_mat==77)=NaN;
    data_mat(data_mat==88)=NaN;
    data_mat(data_mat==99)=NaN;
    data_mat(data_mat==0)=NaN;
    x=data_mat; 
    m=nanmean(x); 
    s=nanstd(x); 
    
    fprintf(FILE_IN, '%s\n', ['Age when ' quest_labels{i} ]);
    fprintf(FILE_IN, '%s\n', [num2str(sprintf('%.1f', m)) ' (' num2str(sprintf('%.1f', s)) ')']);
    indx_nan=find(isnan(x)==1); 
    n=numel(indx_nan); 
    p=n/numel(x)*100; 
    fprintf(FILE_IN, '%s\n\n', ['Missing: ' num2str(sprintf('%.1f', n)) ' (' num2str(sprintf('%.1f', p)) '%)']);
    
end 



%ACE scale
ACE_mat=zeros(r-1,1); 
for i=1:numel(variables)
    D=variables{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat=cell2mat(data_mat); 
    data_mat(data_mat==77)=NaN;
    data_mat(data_mat==88)=NaN;
    data_mat(data_mat==99)=NaN;
    for j=1:numel(data_mat)
        if data_mat(j)==1
            ACE_mat(j)=ACE_mat(j)+1; 
        end 
    end 
    
end 

m=nanmean(ACE_mat); 
s=nanstd(ACE_mat);
new_mat=ACE_mat(isnan(ACE_mat)==0); 
n=numel(new_mat); 
fprintf(FILE_IN, '%s\n\n', ['ACE results: N = ' num2str(n) ', Mean = ' num2str(m) ', SD = ' num2str(s) ]);

for i=1:numel(questions)
    D=questions{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat=cell2mat(data_mat); 
    data_mat(data_mat==77)=NaN;
    data_mat(data_mat==88)=NaN;
    data_mat(data_mat==99)=NaN;
    data_mat(data_mat==0)=NaN;
    indx2=find(isnan(data_mat)==0 & isnan(ACE_mat)==0); 
    x=data_mat(indx2); %interval
    y=ACE_mat(indx2); %ordinal
    [rho,p]=corr(x,y);
    %spearman correlation
    [rho_s, p_s]=corr(x,y,'Type','Spearman'); 
    %nonparametric regression
    m=nanmean(x); 
    s=nanstd(x); 
    
    fprintf(FILE_IN, '%s\n', ['Age when ' quest_labels{i} ]);
    fprintf(FILE_IN, '%s\n', ['N = ' num2str(numel(y))]);
    fprintf(FILE_IN, '%s\n', ['pearson correlation ' num2str(rho) ]);
    fprintf(FILE_IN, '%s\n', ['pvalue ' num2str(p) ]);
    fprintf(FILE_IN, '%s\n', ['spearman correlation ' num2str(rho_s) ]);
    fprintf(FILE_IN, '%s\n\n', ['pvalue ' num2str(p_s) ]);
    if (plot1==1)
        normplot(x); 
        print (gcf, '-dpng', ['normplot' num2str(i)]); 
        close
        if i==1
            normplot(y)
            print (gcf, '-dpng', 'normplot_ACE')
            close
        end 
        
        scatter(x,y); 
        xlabel(['Age when ' quest_labels{i} ]); 
        ylabel('ACE score'); 
        print (gcf, '-dpng', ['plot' num2str(i)]); 
        close
    end
    
end 

%BY AGE----------------------------------------------------------------

%ACE age
ACE_age=zeros(r-1,numel(variables_age)); 
ACE_age_=cell(r-1, numel(variables_age)); 
for i=1:numel(variables_age)
    D=variables_age{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat2=data_mat; 
    ages=double.empty; 
    %fix_dates
    for j=1:numel(data_mat2)
        temp=data_mat2{j};
        if isempty(strfind(temp, '/'))==0
            indx3=strfind(temp, '/'); 
            N=''; 
            for k=1:indx3(1)-1
                N=[N temp(k)]; 
            end 
            data_mat2{j}=str2double(N); 
        elseif isempty(strfind(temp, '-'))==0
            indx3=strfind(temp, '-'); 
            N=''; 
            for k=1:indx3(1)-1
                N=[N temp(k)]; 
            end 
            data_mat2{j}=str2double(N);  
            
        elseif isempty(strfind(temp, ','))==0
            indx3=strfind(temp, ','); 
            N=''; 
            for k=1:indx3(1)-1
                N=[N temp(k)]; 
            end 
            data_mat2{j}=str2double(N); 
        end 
    end 
    data_final=cell2mat(data_mat2); 
    ACE_age(:,i)=data_final; 
    ACE_age_(:,i)=data_mat; 
    
end 
fprintf(FILE_IN, '\n%s\n', 'Earliest age of traumatic events (EATE):' );

ACE_age_final=min(ACE_age, [], 2);

m=nanmean(ACE_age_final); 
s=nanstd(ACE_age_final); 
new_mat=ACE_age_final(isnan(ACE_age_final)==0); 
n=numel(new_mat); 
fprintf(FILE_IN, '%s\n\n', ['AATE results: N = ' num2str(n) ', Mean = ' num2str(m) ', SD = ' num2str(s) ]);

for i=1:numel(questions)
    D=questions{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat=cell2mat(data_mat); 
    data_mat(data_mat==77)=NaN;
    data_mat(data_mat==88)=NaN;
    data_mat(data_mat==99)=NaN;
    data_mat(data_mat==0)=NaN;
    indx2=find(isnan(data_mat)==0 & isnan(ACE_age_final)==0); 
    x=data_mat(indx2); %interval
    y=ACE_age_final(indx2); %ordinal
    [rho,p]=corr(x,y);
    %spearman correlation
    [rho_s, p_s]=corr(x,y,'Type','Spearman'); 
    %nonparametric regression
    
    m=nanmean(x); 
    s=nanstd(x); 
    
    fprintf(FILE_IN, '%s\n', ['Age when ' quest_labels{i} ]);
    fprintf(FILE_IN, '%s\n', ['N = ' num2str(numel(y))]);
    fprintf(FILE_IN, '%s\n', ['pearson correlation ' num2str(rho) ]);
    fprintf(FILE_IN, '%s\n', ['pvalue ' num2str(p) ]);
    fprintf(FILE_IN, '%s\n', ['spearman correlation ' num2str(rho_s) ]);
    fprintf(FILE_IN, '%s\n\n', ['pvalue ' num2str(p_s) ]);
    if (plot2==1)
        normplot(x); 
        print (gcf, '-dpng', ['normplot' num2str(i)]); 
        close
        if i==1
            normplot(y)
            print (gcf, '-dpng', 'normplot_AATE')
            close
        end 
        
        scatter(x,y); 
        xlabel(['Age when ' quest_labels{i} ]); 
        ylabel('Average age of traumatic events (AATE)'); 
        print (gcf, '-dpng', ['plot' num2str(i) '_AATE']); 
        close
    end
    
end 

