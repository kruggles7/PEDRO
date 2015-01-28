load filtered_db_2015_01_18
load GENDER
FILE_IN=fopen('PO_initiation.txt', 'wt'); 
%also load some deomgraphic analysis !
% % 
% % 3. PO initiation variables: mean, range and standard dev for PO
% % initiation age; frequencies and percentages for all other variables.
% % 
% % PO initiation age (RxInitiation_1/Note_1).  Is this correct? 2: RxInitiation_Note1/RxInitiation_1

PO_age='RxInitiation_Note1/RxInitiation_1'; %NOT SURE ABOUT THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
indx=find(strcmp(headers,PO_age)==1); 
indx_male=find(GENDER==1); 
indx_female=find(GENDER==2); 
data_mat=filtered_data(:,indx); 
data_mat=str2double(data_mat); 
ages=data_mat; 
mean_age=nanmean(ages); 
        
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

% % Why initiated taking POs
% % the first 10 look correct (binary, as TRUE and FALSE now)
% % RxInitiation_3
% % Why did you take the prescription opioid(s)? (Check all that apply)
% % 
% % 1	To Avoid Withdrawal 
% % 2	To Facilitate/Enhance Sex
% % 3	To Help Manage Physical Pain 
% % 4	I Was Bored	
% % 5	Curiosity 		
% % 6	To Improve My Mood 
% % 7	To Feel More Sociable 
% % 8	To Party/Hang Out With Friends
% % 9	To Get High 	
% % 10	Other		
% % 88	Don't Know 	
% % 99	Refused To Answer 

reason_started={'RxInitiation_Note1/RxInitiation_3/1', 'RxInitiation_Note1/RxInitiation_3/2','RxInitiation_Note1/RxInitiation_3/3','RxInitiation_Note1/RxInitiation_3/4',...
'RxInitiation_Note1/RxInitiation_3/5','RxInitiation_Note1/RxInitiation_3/6','RxInitiation_Note1/RxInitiation_3/7','RxInitiation_Note1/RxInitiation_3/8','RxInitiation_Note1/RxInitiation_3/9','RxInitiation_Note1/RxInitiation_3/10'}; 
names={'To avoid withdrawl', 'To facilitate/ enhance sex', 'To help manage physical pain', 'Was bored', 'Curiosity', 'To improve mood', 'To feel more sociable', 'To party/ hang out with friends', 'To get high', 'Other'}; 

[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 
results2=cell.empty; 
results2{1,1}='Question'; 
results2{1,2}='Code'; 
results2{1,3}='freq-total'; 
results2{1,4}='% total'; 
results2{1,5}='95% CI'; 
results2{1,6}='freq-males';
results2{1,7}='% males'; 
results2{1,8}='95% CI'; 
results2{1,9}='freq-females'; 
results2{1,10}='% females'; 
results2{1,11}='95% CI'; 
results2{1,12}='p value'; 

z=1.96;
for i=1:numel(reason_started)
    R=reason_started{i}; 
    indx=find(strcmp(headers,R)==1); 
    results2{i+1,1}=names{i}; 
    if numel(indx)==1
        data_mat=filtered_data(:,indx); 
        tf=isa(data_mat,'cell');  
        indx_t=find(strcmp('TRUE',data_mat)==1); 
        if numel(indx_t)>0%tf==1
            indx_t=find(strcmp('TRUE',data_mat)==1);  
            indx_f=find(strcmp('FALSE',data_mat)==1); 
            for j=1:numel(indx_t)
                data_mat{indx_t(j)}=1; 
            end 
            for j=1:numel(indx_f)
                data_mat{indx_f(j)}=0; 
            end 
        end 
        isnum = cellfun(@isnumeric,data_mat);
        data_mat2 = NaN(size(data_mat));
        data_mat2(isnum) = [data_mat{isnum}];
        data_mat=data_mat2; 
 
        indx_male=find(GENDER==1); 
        indx_female=find(GENDER==2); 
        data_=find(isnan(data_mat)==0); 
        results2{i+1,2}=R; 
        
        %TOTAL------------------------------
        N=numel(data_); %total answered
        N_m=numel(intersect(data_,indx_male)); 
        N_f=numel(intersect(data_,indx_female)); 
        indx_yes=find(data_mat==1); 
        results2{i+1,3}=numel(indx_yes); 
        P=numel(indx_yes)/N; 
        upper=((P+z*sqrt(P*(1-P)/N))*100); 
        lower=((P-z*sqrt(P*(1-P)/N))*100) ;
        p=P*100; 
        results2{i+1,4}=[sprintf('%.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results2{i+1,5}=[lower '%-' upper '%']; 
        
        %MALE-------------------------------
        indx_M=intersect(indx_male,indx_yes); 
        results2{i+1,6}=numel(indx_M); 
        P=numel(indx_M)/N_m; 
        upper=((P+z*sqrt(P*(1-P)/N_m))*100); 
        lower=((P-z*sqrt(P*(1-P)/N_m))*100) ;
        p=P*100; 
        results2{i+1,7}=[sprintf('%.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results2{i+1,8}=[lower '%-' upper '%']; 
    
        %FEMALES-------------------
        indx_F=intersect(indx_female,indx_yes); 
        results2{i+1,9}=numel(indx_F); 
        P=numel(indx_F)/N_f; 
        upper=((P+z*sqrt(P*(1-P)/N_f))*100); 
        lower=((P-z*sqrt(P*(1-P)/N_f))*100) ;
        p=P*100; 
        results2{i+1,10}=[sprintf('%.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results2{i+1,11}=[lower '%-' upper '%']; 
        
        x=max(numel(indx_male),numel(indx_female)); 
        stat_mat=nan(x,2); 
        stat_mat(1:numel(indx_male),1)=zeros(numel(indx_male),1);
        stat_mat(1:numel(indx_female),2)=zeros(numel(indx_female),1);  
        stat_mat(1:numel(indx_M),1)=ones(1,numel(indx_M)); 
        stat_mat(1:numel(indx_F),2)=ones(1,numel(indx_F)); 
        [h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
        results2{i+1,12}=p; 
    else
        E
    end 
end 


% % This actually gives a reason in text, not sure how to statistically analyze it
% % RxInitiation_Note1/RxInitiation_4

%%RxInitiation_7
% % When you first took Prescription Opioids nonmedically, with whom did you take it (them)? (Check all that apply)
% % 1	I used them alone	
% % 2	With non drug using acquaintances
% % 3	With drug using acquaintances
% % 4	With non drug using friends 
% % 5	With drug using friends
% % 6	With non drug using main sex partner
% % 7	With drug using main sex partner
% % 8	With non drug using casual sex partner(s)
% % 9	With drug using casual sex partner(s)
% % 10	With relative(s)	
% % 11	Other (please specify)
% % 77	Not Applicable	
% % 88	Don't Know	
% % 99	Refused to Answer	


started_with={'RxInitiation_Note1/RxInitiation_7/1','RxInitiation_Note1/RxInitiation_7/2','RxInitiation_Note1/RxInitiation_7/3','RxInitiation_Note1/RxInitiation_7/4','RxInitiation_Note1/RxInitiation_7/5',...
'RxInitiation_Note1/RxInitiation_7/6','RxInitiation_Note1/RxInitiation_7/7','RxInitiation_Note1/RxInitiation_7/8','RxInitiation_Note1/RxInitiation_7/9','RxInitiation_Note1/RxInitiation_7/10','RxInitiation_Note1/RxInitiation_7/11',}; 
names={'Alone', 'With non drug using acquaintances', 'With drug using acquaintances', 'With non drug using friends', 'With drug using friends', 'With non drug using main sex partner', ...
    'With drug using main sex partner', 'With non drug using casual sex partner (s)', 'With drug using casual sex partner(s)', 'With relative(s)', 'Other'}; 
% % With who initiated POs
% % the first 11 look correct (binary, as TRUE and FALSE now)
% % This actually gives a reason in text, not sure how to statistically analyze it
% % RxInitiation_Note1/RxInitiation_8

results3=cell.empty; 
results3{1,1}='Question'; 
results3{1,2}='Code'; 
results3{1,3}='freq-total'; 
results3{1,4}='% total'; 
results3{1,5}='95% CI'; 
results3{1,6}='freq-males';
results3{1,7}='% males'; 
results3{1,8}='95% CI'; 
results3{1,9}='freq-females'; 
results3{1,10}='% females'; 
results3{1,11}='95% CI';
results3{1,12}='p value'; 

z=1.96;
for i=1:numel(started_with)
    R=started_with{i}; 
    indx=find(strcmp(headers,R)==1); 
    results3{i+1,1}=names{i}; 
    if numel(indx)==1
        data_mat=filtered_data(:,indx); 
        tf=isa(data_mat,'cell');  
        indx_t=find(strcmp('TRUE',data_mat)==1); 
        if numel(indx_t)>0%tf==1
            indx_t=find(strcmp('TRUE',data_mat)==1);  
            indx_f=find(strcmp('FALSE',data_mat)==1); 
            for j=1:numel(indx_t)
                data_mat{indx_t(j)}=1; 
            end 
            for j=1:numel(indx_f)
                data_mat{indx_f(j)}=0; 
            end 
        end 
        isnum = cellfun(@isnumeric,data_mat);
        data_mat2 = NaN(size(data_mat));
        data_mat2(isnum) = [data_mat{isnum}];
        data_mat=data_mat2; 
 
        indx_male=find(GENDER==1); 
        indx_female=find(GENDER==2); 
        data_=find(isnan(data_mat)==0); 
        results3{i+1,2}=R; 
        
        %TOTAL------------------------------
        N=numel(data_); %total answered
        N_m=numel(intersect(data_,indx_male)); 
        N_f=numel(intersect(data_,indx_female)); 
        indx_yes=find(data_mat==1); 
        results3{i+1,3}=numel(indx_yes); 
        P=numel(indx_yes)/N; 
        upper=((P+z*sqrt(P*(1-P)/N))*100); 
        lower=((P-z*sqrt(P*(1-P)/N))*100) ;
        p=P*100; 
        results3{i+1,4}=[sprintf('%.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results3{i+1,5}=[lower '%-' upper '%']; 
        
        %MALE-------------------------------
        indx_M=intersect(indx_male,indx_yes); 
        results3{i+1,6}=numel(indx_M); 
        P=numel(indx_M)/N_m; 
        upper=((P+z*sqrt(P*(1-P)/N_m))*100); 
        lower=((P-z*sqrt(P*(1-P)/N_m))*100) ;
        p=P*100; 
        results3{i+1,7}=[sprintf('%.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results3{i+1,8}=[lower '%-' upper '%']; 
    
        %FEMALES-------------------
        indx_F=intersect(indx_female,indx_yes); 
        results3{i+1,9}=numel(indx_F); 
        P=numel(indx_F)/N_f; 
        upper=((P+z*sqrt(P*(1-P)/N_f))*100); 
        lower=((P-z*sqrt(P*(1-P)/N_f))*100) ;
        p=P*100; 
        results3{i+1,10}=[sprintf('%.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results3{i+1,11}=[lower '%-' upper '%']; 
        
        x=max(numel(indx_male),numel(indx_female)); 
        stat_mat=nan(x,2); 
        stat_mat(1:numel(indx_male),1)=zeros(numel(indx_male),1);
        stat_mat(1:numel(indx_female),2)=zeros(numel(indx_female),1);  
        stat_mat(1:numel(indx_M),1)=ones(1,numel(indx_M)); 
        stat_mat(1:numel(indx_F),2)=ones(1,numel(indx_F)); 
        [h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
        results3{i+1,12}=p; 
    else
        E
    end 
end 

% Where initiated POs

% RxInitiation_Note1/RxInitiation_10 ? range between 1-15 (77,88 etc) key? 
% When you first took prescription opioid(s) nonmedically , where did you take it? 
% 
% 1	The place where I live with my parents
% 2	The place where I live without my parents 
% 3	At a friend's place	
% 4	A sex partners home 
% 5	At your high school 	
% 6	At your college or dorm room 
% 7	At A Dealers Place	
% 8	In a room or house where people go to shoot (not a dealer’s place) 
% 9	In A Club Or Bar 	
% 10	In A Car Or Similar Vehicle 
% 11	In A Public Bathroom 
% 12	In An Apartment Stairwell 
% 13	In An Abandoned Building 
% 14	In an outdoor public space (eg a park or street) 
% 15	Other 		
% 88	Don’t Know	
% 99	Refused To Answer 

% RxInitiation_Note1/RxInitiation_11 ? This actually gives a reason in text, not sure how to statistically analyze it
names={'The place where I live with my parents', 'The place where I live without my parents', 'At a friends place', 'A sex partners home', 'At your high school',...
    'At your college or dorm room', 'At a dealers place', 'In a room or house where people go to shoot (not a dealers place)', 'In a club or bar', 'In a car or similar vehicle',...
    'In a public bathroom', 'In an apartment stairwell', 'In an abandoned building', 'In an outdoor public space', 'Other'}; 
 
R='RxInitiation_Note1/RxInitiation_10'; 
indx=find(strcmp(headers,R)==1); 
where_taken=cell.empty; 
data_mat=filtered_data(:,indx); 
tf=isa(data_mat,'cell');  
indx_t=find(strcmp('TRUE',data_mat)==1); 
if numel(indx_t)>0%tf==1
    indx_t=find(strcmp('TRUE',data_mat)==1);  
    indx_f=find(strcmp('FALSE',data_mat)==1); 
    for j=1:numel(indx_t)
        data_mat{indx_t(j)}=1; 
    end 
    for j=1:numel(indx_f)
        data_mat{indx_f(j)}=0; 
    end 
end 
indx_male=find(GENDER==1); 
indx_female=find(GENDER==2); 
where_taken{1,1}=R; 
where_taken{1,2}='freq-total'; 
where_taken{1,3}='% total'; 
where_taken{1,4}='95% CI'; 
where_taken{1,5}='freq-males';
where_taken{1,6}='% males'; 
where_taken{1,7}='95% CI'; 
where_taken{1,8}='freq-females'; 
where_taken{1,9}='% females'; 
where_taken{1,10}='95% CI'; 
data_mat=str2double(data_mat); 

for i=1:numel(names)
    where_taken{i+1,1}=names{i}; 
    %TOTAL------------------------------
    N=numel(data_); %total answered
    N_m=numel(intersect(data_,indx_male)); 
    N_f=numel(intersect(data_,indx_female)); 
    indx_yes=find(data_mat==i); 
    where_taken{i+1,2}=numel(indx_yes); 
    P=numel(indx_yes)/N; 
    upper=((P+z*sqrt(P*(1-P)/N))*100); 
    lower=((P-z*sqrt(P*(1-P)/N))*100) ;
    p=P*100; 
    where_taken{i+1,3}=[sprintf('%.1f',p) '%']; 
    upper=sprintf('%0.1f',round(upper*10)/10);
    lower=sprintf('%0.1f',round(lower*10)/10);
    where_taken{i+1,4}=[lower '%-' upper '%']; 

    %MALE-------------------------------
    indx_M=intersect(indx_male,indx_yes); 
    where_taken{i+1,5}=numel(indx_M); 
    P=numel(indx_M)/N_m; 
    upper=((P+z*sqrt(P*(1-P)/N_m))*100); 
    lower=((P-z*sqrt(P*(1-P)/N_m))*100) ;
    p=P*100; 
    where_taken{i+1,6}=[sprintf('%.1f',p) '%']; 
    upper=sprintf('%0.1f',round(upper*10)/10);
    lower=sprintf('%0.1f',round(lower*10)/10);
    where_taken{i+1,7}=[lower '%-' upper '%']; 

    %FEMALES-------------------
    indx_F=intersect(indx_female,indx_yes); 
    where_taken{i+1,8}=numel(indx_F); 
    P=numel(indx_F)/N_f; 
    upper=((P+z*sqrt(P*(1-P)/N_f))*100); 
    lower=((P-z*sqrt(P*(1-P)/N_f))*100) ;
    p=P*100; 
    where_taken{i+1,9}=[sprintf('%.1f',p) '%']; 
    upper=sprintf('%0.1f',round(upper*10)/10);
    lower=sprintf('%0.1f',round(lower*10)/10);
    where_taken{i+1,10}=[lower '%-' upper '%']; 
    
    x=max(numel(indx_male),numel(indx_female)); 
    stat_mat=nan(x,2); 
    stat_mat(1:numel(indx_male),1)=zeros(numel(indx_male),1);
    stat_mat(1:numel(indx_female),2)=zeros(numel(indx_female),1);  
    stat_mat(1:numel(indx_M),1)=ones(1,numel(indx_M)); 
    stat_mat(1:numel(indx_F),2)=ones(1,numel(indx_F)); 
    [h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
    where_taken{i+1,11}=p; 
end 
fclose(FILE_IN); 