load filtered_final_2015_05_06
load GENDER
load AGES
load CLASS
load EDUCATION
load INCOME
load RACE
FILE_IN=fopen('Overdose.txt', 'wt'); 
names2={'Borough current live in', 'Currently homeless'}; 
question2={'Soc_Note1/Soc_6', 'Soc_Note1/Soc_13'}; 
borough={'Manhattan', 'Staten Island', 'Brooklyn', 'Bronx', 'Queens'};
OD='Overdose_8'; 
[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 
z=1.96;

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

education={'Did not complete high school', 'High school graduate or GED', 'Some college/Associates degree', 'College graduate or more','NA'}; 
race={'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian/Pacific Islander', 'White', 'Multiracial'}; 
soc_class={'Affluent', 'Upper Middle Class', 'Middle Class', 'Lower Middle Class', 'Poor'}; 
soc_23={'$0-$25,000', '$26,000-$50,000', '$51,000-$75,000', '$76,000-$100,000', '$101,000-$125,000', '$126,000-$150,000', '$151,000-$200,000', '$201,000-$250,000', '$251+'}; 

%-------------------------------------------------------------------------%
%check difference in GENDER------------------------------------------------
%-------------------------------------------------------------------------%
indx_male=find(GENDER==1); 
indx_female=find(GENDER==2);
n=numel(indx_OD); 
indx_m=intersect(indx_male, indx_OD); 
indx_f=intersect(indx_female, indx_OD); 
m=numel(indx_m); 
f=numel(indx_f);
fprintf(FILE_IN, '%s\n', 'Gender'); 
temp=['Number OD: Total ' num2str(n) ', Male ' num2str(m) ', Female ' num2str(f)]; 
fprintf(FILE_IN, '%s\n', temp); 
N=numel(indx_all); 
P=100*n/N; 
M=100*m/numel(indx_male); 
F=100*f/numel(indx_female); 
temp=['Percent OD: Total ' num2str(sprintf('%.1f',P)) '%, Male ' num2str(sprintf('%.1f',M)) '%, Female ' num2str(sprintf('%.1f',F)) '%']; 
fprintf(FILE_IN, '%s\n', temp); 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/N))*100); 
lower=((P-z*sqrt(P*(1-P)/N))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
temp=['95% CI: Total (' num2str(lower) '-' num2str(upper) ') ']; 
fprintf(FILE_IN, '%s', temp); 
M=M/100; 
upper=((M+z*sqrt(M*(1-M)/numel(indx_male)))*100); 
lower=((M-z*sqrt(M*(1-M)/numel(indx_male)))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
temp=['Males (' num2str(lower) '-' num2str(upper) ') ']; 
fprintf(FILE_IN, '%s', temp); 
F=F/100; 
upper=((F+z*sqrt(F*(1-F)/numel(indx_female)))*100); 
lower=((F-z*sqrt(F*(1-F)/numel(indx_female)))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
temp=['Females (' num2str(lower) '-' num2str(upper) ') ']; 
fprintf(FILE_IN, '%s\n', temp);

%p-value
x=max(numel(indx_male),numel(indx_female)); 
stat_mat=nan(x,2); 
stat_mat(1:numel(indx_male),1)=zeros(numel(indx_male),1);
stat_mat(1:numel(indx_female),2)=zeros(numel(indx_female),1);  
stat_mat(1:numel(indx_m),1)=ones(1,numel(indx_m)); 
stat_mat(1:numel(indx_f),2)=ones(1,numel(indx_f)); 
[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['p-value males vs females: ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp); 


%-------------------------------------------------------------------------%
%check difference in RACE-------------------------------------------------
%-------------------------------------------------------------------------%
temp='Race'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(260,6); 
x_plot=zeros(6,1); 
std_plot=zeros(6,1); 
for j=1:6
    indx_race=find (RACE==j) ;
    indx_race_noOD=intersect(indx_race, indx_noOD); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    upper=((P+z*sqrt(P*(1-P)/n))*100); 
    lower=((P-z*sqrt(P*(1-P)/n))*100) ;
    upper=sprintf('%0.1f',round(upper*10)/10);
    lower=sprintf('%0.1f',round(lower*10)/10);
    if n>0
        temp=['Number of ' race{j} ' OD: Total ' num2str(n) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(j)=p; 
    std_plot(j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 


%statistics: 
for j=1:6
    stat1=stat_mat(:,j); 
    indx1=find(stat1>0); 
    if numel(indx1)>0 
        for k=1:6
            stat2=stat_mat(:,k); 
            indx2=find(stat2>0);
            if numel(indx2)>0 && j<k
                [h,p]=ttest2(stat1, stat2); 
                temp=[race{j} ' vs ' race{k} ' p = ' num2str(p)]; 
                fprintf(FILE_IN, '%s\n', temp);
            end 
        end 
    end 
end 
fprintf(FILE_IN, '\n');

% %-------------------------------------------------------------------------%
% %check difference in CLASS-------------------------------------------------
% %-------------------------------------------------------------------------%
% temp='Class'; 
% fprintf(FILE_IN, '%s\n', temp);
% stat_mat=nan(260,5);  
% x_plot=zeros(5,1); 
% std_plot=zeros(5,1);
% for j=1:5
%     indx_race=find (CLASS==j) ;
%     indx_race_noOD=intersect(indx_race, indx_noOD); 
%     indx_race_OD=intersect(indx_race, indx_OD); 
%     n=numel(indx_race); 
%     P=numel(indx_race_OD)/n*100; 
%     p=P; 
%     P=P/100; 
%     upper=((P+z*sqrt(P*(1-P)/n))*100); 
%     lower=((P-z*sqrt(P*(1-P)/n))*100) ;
%     upper=sprintf('%0.1f',round(upper*10)/10);
%     lower=sprintf('%0.1f',round(lower*10)/10);
%     if n>0
%         temp=['Number in ' soc_class{j} ' OD: Total ' num2str(n) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
%         fprintf(FILE_IN, '%s\n', temp); 
%     end 
%     stat_mat(indx_race_noOD,j)=0;
%     stat_mat(indx_race_OD,j)=1; 
%     x_plot(j)=p; 
%     std_plot(j)=z*sqrt(P*(1-P)/n)*100; 
% end 
%  fprintf(FILE_IN, '\n'); 
%  
%  %plot
% y=1:5; 
% bar( y, x_plot); 
% hold on 
% errorbar (y,x_plot,std_plot,'.k', 'MarkerSize',2, 'linewidth',2 ); 
% set(gca, 'xticklabel', soc_class); 
% print (gcf, '-dpdf', [ 'Class.pdf']); 
% close
%  
% %statistics: 
% for j=1:5
%     stat1=stat_mat(:,j); 
%     indx1=find(stat1>0); 
%     if numel(indx1)>0 
%         for k=1:5
%             stat2=stat_mat(:,k); 
%             indx2=find(stat2>0);
%             if numel(indx2)>0 && j<k
%                 [h,p]=ttest2(stat1, stat2); 
%                 temp=[soc_class{j} ' vs ' soc_class{k} ' p = ' num2str(p)]; 
%                 fprintf(FILE_IN, '%s\n', temp);
%             end 
%         end 
%     end 
% end 
% fprintf(FILE_IN, '\n');

%-------------------------------------------------------------------------%
%check difference in EDUCATION---------------------------------------------
%-------------------------------------------------------------------------%
temp='Education'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(260,4); 
x_plot=zeros(4,1); 
std_plot=zeros(4,1); 
for j=1:4
    indx_race=find (EDUCATION==j) ;
    indx_race_noOD=intersect(indx_race, indx_noOD); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    upper=((P+z*sqrt(P*(1-P)/n))*100); 
    lower=((P-z*sqrt(P*(1-P)/n))*100) ;
    upper=sprintf('%0.1f',round(upper*10)/10);
    lower=sprintf('%0.1f',round(lower*10)/10);
    if n>0
        temp=['Number in ' education{j} ' OD: Total ' num2str(n) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(j)=p; 
    std_plot(j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
for j=1:4
    stat1=stat_mat(:,j); 
    indx1=find(stat1>0); 
    if numel(indx1)>0 
        for k=1:4
            stat2=stat_mat(:,k); 
            indx2=find(stat2>0);
            if numel(indx2)>0 && j<k
                [h,p]=ttest2(stat1, stat2); 
                temp=[education{j} ' vs ' education{k} ' p = ' num2str(p)]; 
                fprintf(FILE_IN, '%s\n', temp);
            end 
        end 
    end 
end 
fprintf(FILE_IN, '\n');

%-------------------------------------------------------------------------%
%check difference in INCOME-------------------------------------------------
%-------------------------------------------------------------------------%
temp='Household Income'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(260,3);  
soc_23_new={'$0-$50k', '$51k-$100k', '>$101k'}; 
n=zeros(3,1); 
t=zeros(3,1); 
for j=1:9
    indx_race=find (INCOME==j) ;
    indx_race_noOD=intersect(indx_race, indx_noOD); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    if j<3 %0-50
        n(1)=n(1)+numel(indx_race_OD); 
        t(1)=t(1)+numel(indx_race);
        if stat_mat(indx_race_noOD,1)~=1
            stat_mat(indx_race_noOD,1)=0;
        end 
        stat_mat(indx_race_OD,1)=1; 
    elseif j>2 && j<5 %50-100
        n(2)=n(2)+numel(indx_race_OD); 
        t(2)=t(2)+numel(indx_race); 
        if stat_mat(indx_race_noOD,2)~=1
            stat_mat(indx_race_noOD,2)=0;
        end 
        stat_mat(indx_race_OD,2)=1; 
    else %>100
        n(3)=n(3)+numel(indx_race_OD); 
        t(3)=t(3)+numel(indx_race); 
        if stat_mat(indx_race_noOD,3)~=1
            stat_mat(indx_race_noOD,3)=0;
        end 
        stat_mat(indx_race_OD,3)=1; 
    end 
    if j==2 
        P=n(1)/t(1)*100; 
        p=P; 
        P=P/100; 
        upper=((P+z*sqrt(P*(1-P)/t(1)))*100); 
        lower=((P-z*sqrt(P*(1-P)/t(1)))*100) ;
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        temp=['Number in ' soc_23_new{1} ' OD: Total ' num2str(n(1)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
        fprintf(FILE_IN, '%s\n', temp); 
    elseif j==4
        P=n(2)/t(2)*100; 
        p=P; 
        P=P/100; 
        upper=((P+z*sqrt(P*(1-P)/t(2)))*100); 
        lower=((P-z*sqrt(P*(1-P)/t(2)))*100) ;
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        temp=['Number in ' soc_23_new{2} ' OD: Total ' num2str(n(2)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
        fprintf(FILE_IN, '%s\n', temp); 
    elseif j==9  
        P=n(3)/t(3)*100; 
        p=P; 
        P=P/100; 
        upper=((P+z*sqrt(P*(1-P)/t(3)))*100); 
        lower=((P-z*sqrt(P*(1-P)/t(3)))*100) ;
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        temp=['Number in ' soc_23_new{3} ' OD: Total ' num2str(n(3)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
end 
 fprintf(FILE_IN, '\n'); 

 
%statistics: 
for j=1:3
    stat1=stat_mat(:,j); 
    indx1=find(stat1>0); 
    if numel(indx1)>0 
        for k=1:3
            stat2=stat_mat(:,k); 
            indx2=find(stat2>0);
            if numel(indx2)>0 && j<k
                [h,p]=ttest2(stat1, stat2); 
                temp=[soc_23_new{j} ' vs ' soc_23_new{k} ' p = ' num2str(p)]; 
                fprintf(FILE_IN, '%s\n', temp);
            end 
        end 
    end 
end 
fprintf(FILE_IN, '\n');

% %-------------------------------------------------------------------------%
% %Currently Homeless------------------------------------------------------
% %-------------------------------------------------------------------------%

temp='Currently Homeless'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(260,2); 
x_plot=zeros(2,2); 
std_plot=zeros(2,2); 

indx=find(strcmp(headers,question2{2})==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
data_mat(data_mat==77)=NaN;
data_mat(data_mat==88)=NaN;
data_mat(data_mat==99)=NaN;

indx_homeless=find(data_mat==1); 
indx_home=find(data_mat==0); 

indx_homeless_noOD=intersect(indx_homeless, indx_all); 
indx_homeless_OD=intersect(indx_homeless, indx_OD); 

indx_home_noOD=intersect(indx_home, indx_all); 
indx_home_OD=intersect(indx_home, indx_OD); 

%homeless
n=numel(indx_homeless); 
P=numel(indx_homeless_OD)/n*100; 
p=P; 
P=P/100; 
conf_int=CI_prop(N,P); 
if n>0
    temp=['Number of homeless who have ODed: Total ' num2str(n) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
    fprintf(FILE_IN, '%s\n', temp); 
end 
stat_mat(indx_homeless_noOD,1)=0;
stat_mat(indx_homeless_OD,1)=1; 
x_plot(1,1)=p; 
std_plot(1,1)=z*sqrt(P*(1-P)/n)*100;

%not homeless
n=numel(indx_home); 
P=numel(indx_home_OD)/n*100; 
p=P; 
P=P/100; 
conf_int=CI_prop(N,P); 
if n>0
    temp=['Number of not homeless who have ODed: Total ' num2str(n) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
    fprintf(FILE_IN, '%s\n', temp); 
end 
stat_mat(indx_home_noOD,2)=0;
stat_mat(indx_home_OD,2)=1; 

x_plot(1,2)=p; 
std_plot(1,2)=z*sqrt(P*(1-P)/n)*100; 
fprintf(FILE_IN, '\n');  

%p-value
[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['p-value homeless vs not homeless: ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp); 

y=1:2;  
bar( y, x_plot(1,:)); 
hold on 
errorbar (y,x_plot(1,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
ylabel('% Overdosing'); 
title('Overdosing and Homelessness'); 
xlim([0 3]); 
set(gca, 'xticklabel', {'Homeless', 'Not homeless'}); 
print (gcf, '-dpdf', 'Homeless.pdf'); 
close 

%-------------------------------------------------------------------------%
%borough when started using different drugs-----------------------------------
%-------------------------------------------------------------------------%

%What borough do you currently live in?
% 1	Manhattan 
% 2	Staten Island
% 3	Brooklyn 
% 4	Bronx
% 5	Queens 
temp='Borough'; 
fprintf(FILE_IN, '%s\n', temp);

indx=find(strcmp(headers,question2{1})==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
data_mat(data_mat==77)=NaN;
data_mat(data_mat==88)=NaN;
data_mat(data_mat==99)=NaN;

stat_mat=nan(260,5); 
x_plot=zeros(5,1); 
std_plot=zeros(5,1); 
for j=1:5
    indx_race=find (data_mat==j) ;
    indx_race_noOD=intersect(indx_race, indx_noOD); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    upper=((P+z*sqrt(P*(1-P)/n))*100); 
    lower=((P-z*sqrt(P*(1-P)/n))*100) ;
    upper=sprintf('%0.1f',round(upper*10)/10);
    lower=sprintf('%0.1f',round(lower*10)/10);
    if n>0
        temp=['Number in ' borough{j} ' OD: Total ' num2str(n) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(j)=p; 
    std_plot(j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
 
%statistics: 
for j=1:5
    stat1=stat_mat(:,j); 
    indx1=find(stat1>0); 
    if numel(indx1)>0 
        for k=1:5
            stat2=stat_mat(:,k); 
            indx2=find(stat2>0);
            if numel(indx2)>0 && j<k
                [h,p]=ttest2(stat1, stat2); 
                temp=[borough{j} ' vs ' borough{k} ' p = ' num2str(p)]; 
                fprintf(FILE_IN, '%s\n', temp);
            end 
        end 
    end 
end 
fprintf(FILE_IN, '\n');

%-------------------------------------------------------------------------%
%AGES when started using different drugs-----------------------------------
%-------------------------------------------------------------------------%
names={'Age when started using benzodiazepines regularly','Age when started using prescription opioids', 'Age when first injected any drug',...
    'Age when first used heroin', 'Age when first used heroin regularly','Age when first use benzodiazepines'}; 
questions={'Benchmark_Note1/Benchmark_31', 'Benchmark_Note1/Benchmark_13', 'Benchmark_Note1/Benchmark_19',...
    'Benchmark_Note1/Benchmark_22', 'Benchmark_Note1/Benchmark_25', 'Benchmark_Note1/Benchmark_28'}; 

[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 
results=cell.empty; 
results{1,1}='Question'; 
results{1,2}='Code'; 
results{1,3}='Mean Age OD'; 
results{1,4}='SD age OD';
results{1,5}='95% CI OD';
results{1,6}='Mean Age no OD'; 
results{1,7}='SD age no OD';
results{1,8}='95% CI no OD'; 
results{1,9}='pvalue'; 

indx=find(strcmp(headers,OD)==1); 
data_mat=filtered_data(:,indx); 
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx_OD=find(data_mat==1); 
indx_noOD=find(data_mat==0); 
max_n=max(numel(indx_OD), numel(indx_noOD)); 

x_mat=zeros(numel(questions),2); 
std_mat=zeros(numel(questions),2); 

for i=1:numel(questions)
    E=questions{i}; 
    indx=find(strcmp(headers,E)==1); 
    data_mat=filtered_data(:,indx);
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    data_mat=cell2mat(data_mat); 
    data_mat(data_mat==0)=NaN; 
    data_mat(data_mat==77)=NaN;
    data_mat(data_mat==88)=NaN;
    data_mat(data_mat==99)=NaN;
    results{i+1, 1}=names{i}; 
    results{i+1,2}=E; 
    statmat=nan(max_n,2); 
    if numel(indx)==1
        data_OD=data_mat(indx_OD); 
        statmat(1:numel(data_OD),1)=data_OD; 
        m=nanmean(data_OD); 
        s=nanstd(data_OD); 
        results{i+1,3}=sprintf('%0.1f',m);
        results{i+1,4}=sprintf('%0.1f',s);
        N=numel(indx_OD); 
        upper=m+z*s/sqrt(N); 
        lower=m-z*s/sqrt(N);
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results{i+1,5}=[lower '-' upper]; 
        x_mat(i,1)=m; 
        std_mat(i,1)=s/sqrt(N); 
        
        data_noOD=data_mat(indx_noOD); 
        statmat(1:numel(data_noOD),2)=data_noOD; 
        m=nanmean(data_noOD); 
        s=nanstd(data_noOD); 
        results{i+1,6}=sprintf('%0.1f',m);
        results{i+1,7}=sprintf('%0.1f',s);
        N=numel(indx_noOD); 
        upper=m+z*s/sqrt(N); 
        lower=m-z*s/sqrt(N);
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results{i+1,8}=[lower '-' upper]; 
        [h,p]=ttest2(statmat(:,1), statmat(:,2)); 
        results{i+1,9}=p; 
        x_mat(i,2)=m; 
        std_mat(i,2)=s/sqrt(N); 
    end 
end 

%regular benzo use (yes/no) ---------------------------------------------
B='LifetimeSU_Note1/LifetimeSU_21'; 
%For how many months have you regularly used Benzodiazepines? (Regular use= 3 or more times/week. IF NEVER REGULAR USE TYPE "O")
indx=find(strcmp(headers,B)==1); 
data_mat=filtered_data(:,indx);
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx_no=find(data_mat==0); 
indx_yes=find(data_mat>0); 
indx_y=intersect(indx_yes, indx_OD); 
indx_n=intersect(indx_no, indx_OD); 
stat_mat=nan(260,2); 

n=numel(indx_no);  
P=numel(indx_n)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
fprintf(FILE_IN, '%s\n', 'Regular Benzo use'); 
temp=['Number of non-regular benzo users OD: ' num2str(numel(indx_n)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_no,1)=0; 
stat_mat(indx_n,1)=1; 

n=numel(indx_yes);  
P=numel(indx_y)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
temp=['Number of regular benzo users (1+ months) OD: ' num2str(numel(indx_y)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_yes,2)=0; 
stat_mat(indx_y,2)=1; 

[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['Non-regular vs. regular benzo users p = ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp);
            
                
%injection vs noninjection-------------------------------------------------
I='InjBehavior_Note1/InjBehavior_Note2/InjBehavior_1';  %Have you injected in the past 12 months?
indx=find(strcmp(headers,I)==1); 
data_mat=filtered_data(:,indx);
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 

indx_no=find(data_mat==0); 
indx_yes=find(data_mat>0); 
indx_y=intersect(indx_yes, indx_OD); 
indx_n=intersect(indx_no, indx_OD); 
stat_mat=nan(260,2); 

n=numel(indx_no);  
P=numel(indx_n)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
fprintf(FILE_IN, '%s\n', 'Drug injection'); 
temp=['Number of non-injectors OD: ' num2str(numel(indx_n)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_no,1)=0; 
stat_mat(indx_n,1)=1; 

n=numel(indx_yes);  
P=numel(indx_y)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
temp=['Number of injectors OD: ' num2str(numel(indx_y)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_yes,2)=0; 
stat_mat(indx_y,2)=1; 

[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['Noninjectors vs. injectors p = ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp);


%binging behavior --------------------------------------------------------
B='Bing_Note1/Bing_1'; %in the last 30 days on how many did you binge? 
%For how many months have you regularly used Benzodiazepines? (Regular use= 3 or more times/week. IF NEVER REGULAR USE TYPE "O")
indx=find(strcmp(headers,B)==1); 
data_mat=filtered_data(:,indx);
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx_no=find(data_mat==0); 
indx_yes=find(data_mat>0 & data_mat<10); 
indx_heavy=find(data_mat>9); 
indx_y=intersect(indx_yes, indx_OD); 
indx_n=intersect(indx_no, indx_OD); 
indx_h=intersect(indx_heavy, indx_OD); 
stat_mat=nan(260,3); 

n=numel(indx_no);  
P=numel(indx_n)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
fprintf(FILE_IN, '%s\n', 'Binging behavior'); 
temp=['Number of non-bingers OD: ' num2str(numel(indx_n)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_no,1)=0; 
stat_mat(indx_n,1)=1; 

n=numel(indx_yes);  
P=numel(indx_y)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
temp=['Number of moderate bingers (1-9 times per month) OD: ' num2str(numel(indx_y)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_yes,2)=0; 
stat_mat(indx_y,2)=1; 

n=numel(indx_heavy);  
P=numel(indx_h)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
temp=['Number of heavy bingers (10+ times per month) OD: ' num2str(numel(indx_h)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_heavy,3)=0; 
stat_mat(indx_h,3)=1; 

[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['Non-bingers vs. bingers p = ' num2str(p)]; 
fprintf(FILE_IN, '%s\n', temp);
[h,p]=ttest2(stat_mat(:,1), stat_mat(:,3)); 
temp=['Non-bingers vs. heavy bingers p = ' num2str(p)]; 
fprintf(FILE_IN, '%s\n', temp);
[h,p]=ttest2(stat_mat(:,2), stat_mat(:,3)); 
temp=['Moderate bingers vs. heavy bingers p = ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp);

%social drug use (yes/no)-------------------------------------------------

%hepc (yes/no)------------------------------------------------------------
H='hiv_hcv: hepatitis C Test Results'; 

%For how many months have you regularly used Benzodiazepines? (Regular use= 3 or more times/week. IF NEVER REGULAR USE TYPE "O")
indx=find(strcmp(headers,H)==1); 
data_mat=filtered_data(:,indx);
indx_nan=find(strcmp('NaN', data_mat)==1); 
for j=1:numel(indx_nan)
    data_mat{indx_nan(j)}=NaN; 
end 
data_mat=cell2mat(data_mat); 
indx_no=find(data_mat==0); 
indx_yes=find(data_mat>0); 
indx_y=intersect(indx_yes, indx_OD); 
indx_n=intersect(indx_no, indx_OD); 
stat_mat=nan(260,2); 

n=numel(indx_no);  
P=numel(indx_n)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
fprintf(FILE_IN, '%s\n', 'HCV status'); 
temp=['Number HCV- OD: ' num2str(numel(indx_n)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_no,1)=0; 
stat_mat(indx_n,1)=1; 

n=numel(indx_yes);  
P=numel(indx_y)/n*100; 
p=P; 
P=P/100; 
upper=((P+z*sqrt(P*(1-P)/n))*100); 
lower=((P-z*sqrt(P*(1-P)/n))*100) ;
upper=sprintf('%0.1f',round(upper*10)/10);
lower=sprintf('%0.1f',round(lower*10)/10);
temp=['Number of HCV+ OD: ' num2str(numel(indx_y)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI (' num2str(lower) '-' num2str(upper) ') '];  
fprintf(FILE_IN, '%s\n', temp); 
stat_mat(indx_yes,2)=0; 
stat_mat(indx_y,2)=1; 

[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['HCV- vs. HCV+ p = ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp);
            

