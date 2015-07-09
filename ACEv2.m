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
    fprintf(FILE_IN, '%s\n', ['N = ' num2str(numel(y)) ', Mean = ' num2str(m) ', SD = ' num2str(s) ]);
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
fprintf(FILE_IN, '\n%s\n', 'Average age of traumatic events (AATE):' );
ACE_age_final=nanmean(ACE_age,2); 

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
    
    
    fprintf(FILE_IN, '%s\n', ['Age when ' quest_labels{i} ]);
    fprintf(FILE_IN, '%s\n', ['N ' num2str(numel(y)) ]);
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

