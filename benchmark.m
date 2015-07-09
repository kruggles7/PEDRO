load filtered_final_2015_05_06
load GENDER
load AGES

names={'First used POs nonmedically', 'First used benzodiazepines nonmedically', 'Started using POs nonmedically on a regular* basis', ...
    'First used heroin', 'Start using benzodiazepines nonmedically on a regular* basis', 'Started using heroin on a regular* basis',...
    'Started injecting POs on a regular* basis', 'Entered drug treatment for the first time', 'First injected heroin',... 
    'First injected POs', 'First overdosed'}; 

questions={'Benchmark_Note1/Benchmark_13', 'Benchmark_Note1/Benchmark_28', 'Benchmark_Note1/Benchmark_14',...
    'Benchmark_Note1/Benchmark_22', 'Benchmark_Note1/Benchmark_31', 'Benchmark_Note1/Benchmark_25',...
    'Benchmark_Note1/Benchmark_21', 'Benchmark_Note1/Benchmark_34', 'Benchmark_Note1/Benchmark_24', ...
    'Benchmark_Note1/Benchmark_20','Overdose_1_group/Overdose_9' }; 


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

[r,c]=size(INJECTORS); 
results=cell.empty; 
results{1,1}='Question'; 
results{1,2}='Code'; 
results{1,3}='N'; 
results{1,4}='% total'; 
results{1,5}='Mean Age'; 
results{1,6}='SD age';
results{1,7}='95% CI'; 
for j=1:11
    results{1,7+j}=['pvalue ' names{j}]; 
end 
total_N=numel(GENDER_); 
statmat=nan(total_N,11); 

z=1.96; 
for i=1:numel(questions)
    E=questions{i}; 
    indx=find(strcmp(headers,E)==1); 
    results{i+1,1}=names{i}; 
    results{i+1,2}=E; 
    
    if numel(indx)==1
        data_mat=INJECTORS(:,indx); 
        indx_nan=find(strcmp('NaN', data_mat)==1); 
        for j=1:numel(indx_nan)
            data_mat{indx_nan(j)}=NaN; 
        end  
        data_mat2=cell2mat(data_mat);
        data_mat2(data_mat2==0)=NaN; 
        data_mat2(data_mat2==77)=NaN;
        data_mat2(data_mat2==88)=NaN;
        data_mat2(data_mat2==99)=NaN;
        statmat(:,i)=data_mat2; 
        indx_all=find(data_mat2>0); 
        n=100*numel(indx_all)/total_N; 
        results{i+1,3}=numel(indx_all); 
        results{i+1,4}=sprintf('%0.1f',n); 
        m=nanmean(data_mat2); 
        results{i+1,5}=sprintf('%0.1f',m); 
        s=nanstd(data_mat2); 
        results{i+1,6}=sprintf('%0.1f',s);    
        P=n/100; 
        N=numel(indx_all); 
        upper=m+z*s/sqrt(N); 
        lower=m-z*s/sqrt(N);
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results{i+1,7}=[lower '-' upper]; 
    end
end 

for i=1:numel(questions)
    stat1=statmat(:,i); 
    for j=1:numel(questions)
        stat2=statmat(:,j); 
        if j~=i
            [h,p]=ttest2(stat1, stat2); 
            results{i+1,j+7}=p; 
        end 
    end
end
