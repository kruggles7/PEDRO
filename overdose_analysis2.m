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

%age at first overdose
A='Overdose_1_group/Overdose_9'; 
indx=find(strcmp(headers,A)==1); 
data_mat=OVERDOSE(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
age_first=cell2mat(data_mat); 

%times overdose
T='Overdose_1_group/Overdose_10'; 
indx=find(strcmp(headers,T)==1); 
data_mat=OVERDOSE(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
times=cell2mat(data_mat); 


%date of most recent OD 
B='Soc_Note1/Soc_3'; %birthday
indx=find(strcmp(headers,B)==1); 
data_mat=OVERDOSE(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
birth_date=data_mat; 

R='Overdose_1_group/Overdose_12'; 
indx=find(strcmp(headers,R)==1); 
data_mat=OVERDOSE(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
for j=1:numel(data_mat)
    if isnumeric(data_mat{j})==1
         data_mat{j}=NaN; 
    end 
end 
last_od=data_mat; 

age_last=double.empty; 
for j=1:numel(last_od)
    temp=last_od{j}; 
    new_temp=strrep(temp, '.', '/'); 
    LAST_OD=strrep(new_temp, '-', '/'); 
    temp=birth_date{j}; 
    new_temp=strrep(temp, '.', '/'); 
    BIRTH=strrep(new_temp, '-', '/'); 
    if isnan(BIRTH)==0
        if isnan(LAST_OD)==0
            numdays=datenum(LAST_OD)-datenum(BIRTH); 
            numyears=numdays/365; 
            age_last(j)=numyears; 
        else
            age_last(j)=NaN; 
        end 
    else
        age_last(j)=NaN; 
    end 
end 
age_last=age_last'; 
age_last=round(age_last); 
exclude=0; 
for i=1:numel(age_last)
    if age_first(i)>age_last(i)
        exclude=exclude+1; 
        age_last(i)=NaN; 
        age_first(i)=NaN; 
    end
end 

%-------------------------------------------------------------------------%
%AGES when started using different drugs-----------------------------------
%-------------------------------------------------------------------------%
names={'Age when started using benzodiazepines regularly','Age when started using prescription opioids', 'Age when first injected any drug',...
    'Age when first used heroin', 'Age when first used heroin regularly','Age when first use benzodiazepines'}; 
questions={'Benchmark_Note1/Benchmark_31', 'Benchmark_Note1/Benchmark_13', 'Benchmark_Note1/Benchmark_19',...
    'Benchmark_Note1/Benchmark_22', 'Benchmark_Note1/Benchmark_25', 'Benchmark_Note1/Benchmark_28'}; 

for i=1:numel(questions)
    plot_count=1; 
    E=questions{i}; 
    indx=find(strcmp(headers,E)==1); 
    data_mat=OVERDOSE(:,indx);
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat=cell2mat(data_mat); 
    data_mat(data_mat==0)=NaN; 
    data_mat(data_mat==77)=NaN;
    data_mat(data_mat==88)=NaN;
    data_mat(data_mat==99)=NaN;
    
    years_use=double.empty; 
    first_od=double.empty; 
    last_od=double.empty; 
    for j=1:numel(data_mat)
        %finds the number of years each subject has been doing x behavior
        if isnan(data_mat(j))==0 && (AGES(j)>=data_mat(j))
            years_use(j,1)=AGES(j)-data_mat(j); 
        else
            years_use(j,1)=NaN; 
        end 
        %finds the when the first OD occured (relative to the number of years 
        %after starting behavior x) 
        if isnan(data_mat(j))==0 
            first_od(j,1)=age_first(j)-data_mat(j); 
            last_od(j,1)=age_last(j)-data_mat(j); 
            plot([0 years_use(j)], [plot_count plot_count], '-k'); 
            hold on
            scatter(first_od(j), plot_count,10, '*b'); 
            hold on
            scatter(last_od(j), plot_count, 10, 'or', 'filled'); 
            plot_count=plot_count+1; 
        else
            first_od(j,1)=NaN; 
            last_od(j,1)=NaN; 
        end 
    end 
    title(names{i}); 
    xlabel('years since starting use'); 
    ylabel('participants'); 
    print(gcf, '-dpng', ['od_trajectory_' num2str(i)]); 
    close all; 
    
end 