load filtered_db_2015_02_24
load GENDER
load AGES
load CLASS
load EDUCATION
load INCOME
load RACE
FILE_IN=fopen('Overdose_times.txt', 'wt'); 
names2={'Borough current live in', 'Currently homeless'}; 
question2={'Soc_Note1/Soc_6', 'Soc_Note1/Soc_13'}; 
OD='Overdose_1_group/Overdose_10'; 
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
data_mat(data_mat==77)=NaN;
data_mat(data_mat==88)=NaN;
data_mat(data_mat==99)=NaN;
indx_OD=find(data_mat==1 | data_mat==2); 
indx_noOD=find(data_mat==0); 
indx_OD_more=find(data_mat>2); 
indx_all=find(isnan(data_mat)==0); 

education={'Did not complete high school', 'High school graduate or GED', 'Some college/Associates degree', 'College graduate or more','NA'}; 
race={'American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian/Pacific Islander', 'White', 'Multiracial'}; 
soc_class={'Affluent', 'Upper Middle Class', 'Middle Class', 'Lower Middle Class', 'Poor'}; 
soc_23={'$0-$25,000', '$26,000-$50,000', '$51,000-$75,000', '$76,000-$100,000', '$101,000-$125,000', '$126,000-$150,000', '$151,000-$200,000', '$201,000-$250,000', '$251+'}; 

%-------------------------------------------------------------------------%
%check difference in GENDER------------------------------------------------
%-------------------------------------------------------------------------%
x_plot=double.empty; 
std_plot=double.empty; 
indx_male=find(GENDER==1); 
indx_female=find(GENDER==2);
n=numel(indx_OD); 
indx_m=intersect(indx_male, indx_OD); 
indx_f=intersect(indx_female, indx_OD); 
m=numel(indx_m); 
f=numel(indx_f);
fprintf(FILE_IN, '%s\n', 'Gender'); 
temp=['Number OD 1-2 times: Total ' num2str(n) ', Male ' num2str(m) ', Female ' num2str(f)]; 
fprintf(FILE_IN, '%s\n', temp); 

N=numel(indx_all); 
P=100*n/N; 
M=100*m/numel(indx_male); 
F=100*f/numel(indx_female); 
temp=['Percent OD 1-2 times: Total ' num2str(sprintf('%.1f',P)) '%, Male ' num2str(sprintf('%.1f',M)) '%, Female ' num2str(sprintf('%.1f',F)) '%']; 
fprintf(FILE_IN, '%s\n', temp); 
P=P/100; 
conf_int=CI_prop(N,P); 
temp=['95% CI: Total ' conf_int ', ']; 
fprintf(FILE_IN, '%s', temp); 

M=M/100; 
conf_int=CI_prop(numel(indx_male),M); 
temp=['Males ' conf_int ', ']; 
fprintf(FILE_IN, '%s', temp); 

F=F/100; 
conf_int=CI_prop(numel(indx_female),F); 
temp=['Females ' conf_int]; 
fprintf(FILE_IN, '%s\n', temp);

%p-value
x=max(numel(indx_male),numel(indx_female)); 
stat_mat=nan(x,2); 
stat_mat(1:numel(indx_male),1)=zeros(numel(indx_male),1);
stat_mat(1:numel(indx_female),2)=zeros(numel(indx_female),1);  
stat_mat(1:numel(indx_m),1)=ones(1,numel(indx_m)); 
stat_mat(1:numel(indx_f),2)=ones(1,numel(indx_f)); 
[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['p-value males vs females 1-2 times: ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp); 

%> 2 times
n=numel(indx_OD_more); 
indx_m=intersect(indx_male, indx_OD_more); 
indx_f=intersect(indx_female, indx_OD_more); 
m=numel(indx_m); 
f=numel(indx_f);
fprintf(FILE_IN, '%s\n', 'Gender'); 
temp=['Number OD >2 times: Total ' num2str(n) ', Male ' num2str(m) ', Female ' num2str(f)]; 
fprintf(FILE_IN, '%s\n', temp); 
x_plot=[M*100 F*100]; 
s_m=z*sqrt(M*(1-M)/numel(indx_male))*100; 
s_f=z*sqrt(F*(1-F)/numel(indx_female))*100; 
std_plot=[s_m s_f]; 

N=numel(indx_all); 
P=100*n/N; 
M=100*m/numel(indx_male); 
F=100*f/numel(indx_female); 
temp=['Percent OD >2 times: Total ' num2str(sprintf('%.1f',P)) '%, Male ' num2str(sprintf('%.1f',M)) '%, Female ' num2str(sprintf('%.1f',F)) '%']; 
fprintf(FILE_IN, '%s\n', temp); 
P=P/100; 
conf_int=CI_prop(N,P); 
temp=['95% CI: Total ' conf_int ', ']; 
fprintf(FILE_IN, '%s', temp); 

M=M/100; 
conf_int=CI_prop(numel(indx_male),M); 
temp=['Males ' conf_int ', ']; 
fprintf(FILE_IN, '%s', temp); 

F=F/100; 
conf_int=CI_prop(numel(indx_female),F); 
temp=['Females ' conf_int]; 
fprintf(FILE_IN, '%s\n', temp);
x_plot(2,:)=[M*100 F*100]; 
s_m=z*sqrt(M*(1-M)/numel(indx_male))*100; 
s_f=z*sqrt(F*(1-F)/numel(indx_female))*100; 
std_plot(2,:)=[s_m s_f]; 

%plot
y=1:3:6; 
bar( y, x_plot(1,:), 0.25, 'b'); 
hold on 
errorbar (y,x_plot(1,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=2:3:6; 
bar( y, x_plot(2,:), 0.25, 'r'); 
hold on 
errorbar (y,x_plot(2,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
set(gca, 'xtick', 1.5:3:6); 
set(gca, 'xticklabel', {'Males', 'Females'});  
ylabel('% Overdosing'); 
title('Overdosing and Gender');   
print (gcf, '-dpdf', 'Gender_v2.pdf');
close

%p-value
x=max(numel(indx_male),numel(indx_female)); 
stat_mat=nan(x,2); 
stat_mat(1:numel(indx_male),1)=zeros(numel(indx_male),1);
stat_mat(1:numel(indx_female),2)=zeros(numel(indx_female),1);  
stat_mat(1:numel(indx_m),1)=ones(1,numel(indx_m)); 
stat_mat(1:numel(indx_f),2)=ones(1,numel(indx_f)); 
[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['p-value males vs females >2 times: ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp); 


%-------------------------------------------------------------------------%
%check difference in RACE-------------------------------------------------
%-------------------------------------------------------------------------%
temp='Race OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,6); 
x_plot=zeros(2,6); 
std_plot=zeros(2,6); 
for j=1:6
    indx_race=find (RACE==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    conf_int=CI_prop(n,P); 
    if n>0
        temp=['Number of ' race{j} ' OD 1-2 times: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(1,j)=p; 
    std_plot(1,j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 

%statistics: 
temp='Statistics OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
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

temp='Race, >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,6);  
for j=1:6
    indx_race=find (RACE==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD_more); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    conf_int=CI_prop(n,P); 
    if n>0
        temp=['Number of ' race{j} ' OD >2 times: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(2,j)=p; 
    std_plot(2,j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 

%statistics: 
temp='Statistics OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
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

 
%plot
y=1:3:18; 
bar( y, x_plot(1,:), 0.25, 'b'); 
hold on 
errorbar (y,x_plot(1,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=2:3:18; 
bar( y, x_plot(2,:), 0.25, 'r'); 
errorbar (y,x_plot(2,:),std_plot(2,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
ylabel('% Overdosing'); 
title('Overdosing and Race'); 
set(gca, 'xtick', 1.5:3:18); 
legend('1-2 times', '>2 times', 'Location', 'SouthOutside'); 
set(gca, 'xticklabel', race); 
print (gcf, '-dpdf',  'Race_v2.pdf'); 
close

%-------------------------------------------------------------------------%
%check difference in CLASS-------------------------------------------------
%-------------------------------------------------------------------------%
temp='Class OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,5);  
x_plot=zeros(2,5); 
std_plot=zeros(2,5);
for j=1:5
    indx_race=find (CLASS==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    conf_int=CI_prop(n,P); 
    if n>0
        temp=['Number in ' soc_class{j} ' OD: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(1,j)=p; 
    std_plot(1,j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
temp='Statistics OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
for j=1:5
    stat1=stat_mat(:,j); 
    indx1=find(stat1>0); 
    if numel(indx1)>0 
        for k=1:5
            stat2=stat_mat(:,k); 
            indx2=find(stat2>0);
            if numel(indx2)>0 && j<k
                [h,p]=ttest2(stat1, stat2); 
                temp=[soc_class{j} ' vs ' soc_class{k} ' p = ' num2str(p)]; 
                fprintf(FILE_IN, '%s\n', temp);
            end 
        end 
    end 
end 
fprintf(FILE_IN, '\n');

temp='Class OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,5);  
for j=1:5
    indx_race=find (CLASS==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD_more); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    conf_int=CI_prop(n,P); 
    if n>0
        temp=['Number in ' soc_class{j} ' OD: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(2,j)=p; 
    std_plot(2,j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
temp='Statistics OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
for j=1:5
    stat1=stat_mat(:,j); 
    indx1=find(stat1>0); 
    if numel(indx1)>0 
        for k=1:5
            stat2=stat_mat(:,k); 
            indx2=find(stat2>0);
            if numel(indx2)>0 && j<k
                [h,p]=ttest2(stat1, stat2); 
                temp=[soc_class{j} ' vs ' soc_class{k} ' p = ' num2str(p)]; 
                fprintf(FILE_IN, '%s\n', temp);
            end 
        end 
    end 
end 
fprintf(FILE_IN, '\n');

 %plot
 y=1:3:15; 
bar( y, x_plot(1,:), 0.25, 'b'); 
hold on 
errorbar (y,x_plot(1,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=2:3:15; 
bar( y, x_plot(2,:), 0.25, 'r'); 
errorbar (y,x_plot(2,:),std_plot(2,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
ylabel('% Overdosing'); 
title('Overdosing and Socioeconomic Class'); 
set(gca, 'xtick', 1.5:3:15); 
legend('1-2 times', '>2 times', 'Location', 'SouthOutside'); 
set(gca, 'xticklabel', soc_class); 
print (gcf, '-dpdf', 'Class_v2.pdf'); 
close

%-------------------------------------------------------------------------%
%check difference in EDUCATION---------------------------------------------
%-------------------------------------------------------------------------%
temp='Education OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,4); 
x_plot=zeros(2, 4); 
std_plot=zeros(2, 4); 
for j=1:4
    indx_race=find (EDUCATION==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100;
    conf_int=CI_prop(n,P); 
    if n>0
        temp=['Number in ' education{j} ' OD: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(1, j)=p; 
    std_plot(1, j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
temp='Statistics OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
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

temp='Education OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,4); 
for j=1:4
    indx_race=find (EDUCATION==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD_more); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100;
    conf_int=CI_prop(n,P); 
    if n>0
        temp=['Number in ' education{j} ' OD: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(2, j)=p; 
    std_plot(2, j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
temp='Statistics OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
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

%plot
y=1:3:12; 
bar( y, x_plot(1,:), 0.25, 'b'); 
hold on 
errorbar (y,x_plot(1,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=2:3:12; 
bar( y, x_plot(2,:), 0.25, 'r'); 
errorbar (y,x_plot(2,:),std_plot(2,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
ylabel('% Overdosing'); 
title('Overdosing and Socioeconomic Class'); 
set(gca, 'xtick', 1.5:3:12); 
set(gca, 'xticklabel', education); 
legend('1-2 times', '>2 times', 'Location', 'SouthOutside'); 
print (gcf, '-dpdf',  'Education_v2.pdf'); 
close

%-------------------------------------------------------------------------%
%check difference in INCOME-------------------------------------------------
%-------------------------------------------------------------------------%
temp='Household Income OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,9); 
x_plot=zeros(2,9); 
std_plot=zeros(2,9); 
for j=1:9
    indx_race=find (INCOME==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    conf_int=CI_prop(n,P); 
    if n>0
        temp=['Number in ' soc_23{j} ' OD: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(1,j)=p; 
    std_plot(1,j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
temp='Statistics OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
for j=1:9
    stat1=stat_mat(:,j); 
    indx1=find(stat1>0); 
    if numel(indx1)>0 
        for k=1:9
            stat2=stat_mat(:,k); 
            indx2=find(stat2>0);
            if numel(indx2)>0 && j<k
                [h,p]=ttest2(stat1, stat2); 
                temp=[soc_23{j} ' vs ' soc_23{k} ' p = ' num2str(p)]; 
                fprintf(FILE_IN, '%s\n', temp);
            end 
        end 
    end 
end 
fprintf(FILE_IN, '\n');

temp='Household Income OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,9); 
for j=1:9
    indx_race=find (INCOME==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD_more); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    conf_int=CI_prop(n,P); 
    if n>0
        temp=['Number in ' soc_23{j} ' OD: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(2,j)=p; 
    std_plot(2,j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
temp='Statistics OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
for j=1:9
    stat1=stat_mat(:,j); 
    indx1=find(stat1>0); 
    if numel(indx1)>0 
        for k=1:9
            stat2=stat_mat(:,k); 
            indx2=find(stat2>0);
            if numel(indx2)>0 && j<k
                [h,p]=ttest2(stat1, stat2); 
                temp=[soc_23{j} ' vs ' soc_23{k} ' p = ' num2str(p)]; 
                fprintf(FILE_IN, '%s\n', temp);
            end 
        end 
    end 
end 
fprintf(FILE_IN, '\n');


 %plot
y=1:3:27; 
bar( y, x_plot(1,:), 0.25, 'b'); 
hold on 
errorbar (y,x_plot(1,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=2:3:27; 
bar( y, x_plot(2,:), 0.25, 'r'); 
errorbar (y,x_plot(2,:),std_plot(2,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
ylabel('% Overdosing'); 
title('Overdosing and Socioeconomic Class'); 
set(gca, 'xtick', 1.5:3:27); 
set(gca, 'xticklabel', soc_23); 
legend('1-2 times', '>2 times', 'Location', 'SouthOutside'); 
print (gcf, '-dpdf', 'Income_v2.pdf'); 
close

% %-------------------------------------------------------------------------%
% %Currently Homeless------------------------------------------------------
% %-------------------------------------------------------------------------%

temp='Currently Homeless OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,2); 
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
conf_int=CI_prop(n,P); 
if n>0
    temp=['Number of homeless who have ODed: Total ' num2str(numel(indx_homeless_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
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
conf_int=CI_prop(n,P); 
if n>0
    temp=['Number of not homeless who have ODed: Total ' num2str(numel(indx_home_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
    fprintf(FILE_IN, '%s\n', temp); 
end 
stat_mat(indx_home_noOD,2)=0;
stat_mat(indx_home_OD,2)=1; 

x_plot(1,2)=p; 
std_plot(1,2)=z*sqrt(P*(1-P)/n)*100; 
fprintf(FILE_IN, '\n');  

%p-value
[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['p-value homeless vs not homeless 1-2 times: ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp); 

%>2 times! 
temp='Currently Homeless OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
indx_homless_noOD=intersect(indx_homeless, indx_all); 
indx_homeless_OD=intersect(indx_homeless, indx_OD_more);

n=numel(indx_homeless); 
P=numel(indx_homeless_OD)/n*100; 
p=P; 
P=P/100; 
conf_int=CI_prop(n,P); 
if n>0
    temp=['Number of homeless who have ODed: Total ' num2str(numel(indx_homeless_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
    fprintf(FILE_IN, '%s\n', temp); 
end 
stat_mat(indx_homeless_noOD,1)=0;
stat_mat(indx_homeless_OD,1)=1; 
x_plot(2,1)=p; 
std_plot(2,1)=z*sqrt(P*(1-P)/n)*100;

%not homeless
n=numel(indx_home); 
P=numel(indx_home_OD)/n*100; 
p=P; 
P=P/100; 
conf_int=CI_prop(n,P); 
if n>0
    temp=['Number of not homeless who have ODed: Total ' num2str(numel(indx_home_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
    fprintf(FILE_IN, '%s\n', temp); 
end 
stat_mat(indx_home_noOD,2)=0;
stat_mat(indx_home_OD,2)=1; 

x_plot(2,2)=p; 
std_plot(2,2)=z*sqrt(P*(1-P)/n)*100; 
fprintf(FILE_IN, '\n'); 
 
%p-value
[h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
temp=['p-value homeless vs not homeless >2 times: ' num2str(p)]; 
fprintf(FILE_IN, '%s\n\n', temp); 

%plot
y=1:3:6;  
bar( y, x_plot(1,:), 0.25, 'b'); 
hold on 
errorbar (y,x_plot(1,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=2:3:6; 
bar( y, x_plot(2,:), 0.25, 'r'); 
errorbar (y,x_plot(2,:),std_plot(2,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
ylabel('% Overdosing'); 
title('Overdosing and Homelessness'); 
set(gca, 'xtick', 1.5:3:27); 
set(gca, 'xticklabel', {'Homeless', 'Not homeless'}); 
legend('1-2 times', '>2 times', 'Location', 'SouthOutside'); 
print (gcf, '-dpdf', 'Homeless_v2.pdf'); 
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

stat_mat=nan(164,5); 
x_plot=zeros(2,5); 
std_plot=zeros(2,5); 
for j=1:5
    indx_race=find (data_mat==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    conf_int=CI_prop(N,P); 
    if n>0
        temp=['Number in ' borough{j} ' OD: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(1,j)=p; 
    std_plot(1,j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
temp='Statistics OD 1-2 times'; 
fprintf(FILE_IN, '%s\n', temp);
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

temp='Borough OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
stat_mat=nan(164,9); 
for j=1:5
    indx_race=find (data_mat==j) ;
    indx_race_noOD=intersect(indx_race, indx_all); 
    indx_race_OD=intersect(indx_race, indx_OD_more); 
    n=numel(indx_race); 
    P=numel(indx_race_OD)/n*100; 
    p=P; 
    P=P/100; 
    conf_int=CI_prop(N,P); 
    if n>0
        temp=['Number in ' borough{j} ' OD: Total ' num2str(numel(indx_race_OD)) ', ' num2str(sprintf('%.1f',p)) '%, 95% CI ' conf_int];  
        fprintf(FILE_IN, '%s\n', temp); 
    end 
    stat_mat(indx_race_noOD,j)=0;
    stat_mat(indx_race_OD,j)=1; 
    x_plot(2,j)=p; 
    std_plot(2,j)=z*sqrt(P*(1-P)/n)*100; 
end 
 fprintf(FILE_IN, '\n'); 
 
%statistics: 
temp='Statistics OD >2 times'; 
fprintf(FILE_IN, '%s\n', temp);
for j=1:9
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


 %plot
y=1:3:15; 
bar( y, x_plot(1,:), 0.25, 'b'); 
hold on 
errorbar (y,x_plot(1,:),std_plot(1,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=2:3:15; 
bar( y, x_plot(2,:), 0.25, 'r'); 
errorbar (y,x_plot(2,:),std_plot(2,:),'.k', 'MarkerSize',2, 'linewidth',2 ); 
ylabel('% Overdosing'); 
title('Overdosing and Borough'); 
set(gca, 'xtick', 1.5:3:15); 
set(gca, 'xticklabel', borough); 
legend('1-2 times', '>2 times', 'Location', 'SouthOutside'); 
print (gcf, '-dpdf', 'Borough_v2.pdf'); 
close


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
results{1,3}='Mean Age OD 1-2 times'; 
results{1,4}='SD age OD 1-2 times';
results{1,5}='95% CI OD 1-2 times';
results{1,6}='Mean Age OD >2 times'; 
results{1,7}='SD age OD >2 times';
results{1,8}='95% CI OD >2 times';
results{1,9}='1-2 vs. >2 times'; 

max_n=max(numel(indx_OD), numel(indx_noOD));
max_n=max(max_n, numel(indx_OD_more)); 

x_mat=zeros(numel(questions),3); 
std_mat=zeros(numel(questions),3); 

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
    statmat=nan(max_n,3); 
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
        
        data_OD_more=data_mat(indx_OD_more); 
        statmat(1:numel(data_OD_more),2)=data_OD_more; 
        m=nanmean(data_OD_more); 
        s=nanstd(data_OD_more); 
        results{i+1,6}=sprintf('%0.1f',m);
        results{i+1,7}=sprintf('%0.1f',s);
        N=numel(data_OD_more); 
        upper=m+z*s/sqrt(N); 
        lower=m-z*s/sqrt(N);
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results{i+1,8}=[lower '-' upper]; 
        x_mat(i,2)=m; 
        std_mat(i,2)=s/sqrt(N);
        
        [h,p]=ttest2(statmat(:,1), statmat(:,2)); 
        results{i+1,9}=p; 
    end 
end 


y=1:3:numel(questions)*3; 
bar( y, x_mat(:,1), 0.25, 'b'); 
hold on 
errorbar (y,x_mat(:,1),std_mat(:,1),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=2:3:numel(questions)*3; 
bar(y, x_mat(:,2),0.25, 'r' ); 
errorbar (y,x_mat(:,2),std_mat(:,2),'.k', 'MarkerSize',2, 'linewidth',2 ); 
y=3:4:numel(questions)*4; 

tick=1.5:3:numel(questions)*3; 
set(gca, 'xtick', tick); 
set(gca, 'xticklabel', names); 
ylabel('% Overdosing'); 
title('Overdosing and Age of Drug Initiation');
legend('1-2 times', '>2 times', 'Location', 'SouthOutside'); 
print (gcf, '-dpdf', 'Ages_v2.pdf'); 
close
