cd matrices
load filtered_db_2015_02_24
cd ..

FILE_IN=fopen('frequency_2015_04_08.txt', 'wt'); 
[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:);

variables={'LifetimeSU_Note1/LifetimeSU_11',... 
'LifetimeSU_Note1/LifetimeSU_12', 'LifetimeSU_Note1/LifetimeSU_13', 'LifetimeSU_Note1/LifetimeSU_24', ...
'LifetimeSU_Note1/LifetimeSU_27', ...
'LifetimeSU_Note1/LifetimeSU_28', 'LifetimeSU_Note1/LifetimeSU_30', 'LifetimeSU_Note1/LifetimeSU_48' ... 
'DaysSU_Note1/DaysSU_25_group/DaysSU_76', 'DaysSU_Note1/DaysSU_26_group/DaysSU_78', ...
'DaysSU_Note1/DaysSU_104', 'DaysSU_Note1/DaysSU_106',  'DaysSU_Note1/DaysSU_124'}; 

labels={'Other drugs used in lifetime',...
    'regular cocaine use', 'regular crack use', 'regular speedball use',...
    'Injected drugs', ...
    'regular injected cocaine use', 'regular injected crack use', 'regular injected speedball use'...
    'cocaine use in the past 30 days', 'crack use in the past 30 days', ...
    'injected cocaine use in the past 30 days', 'injected crack use in the past 30 days', 'injected speedball use in the past 30 days' }; 

type=[1, 2, 2, 2, 3, 4, 4, 4, 5, 5, 6, 6, 6]; 
drugs={'cocaine', 'crack', 'speedball'}; 

indx_mat=zeros(r-1,3); 
indx_mat2=zeros(r-1,3); 
reg_mat=zeros(3,r-1); 
reg_inj_mat=zeros(3,r-1); 

for i=1:numel(variables)
    D=variables{i}; 
    indx=find(strcmp(headers,D)==1); 
    data_mat=filtered_data(:,indx); 
    indx_nan=find(strcmp('NaN', data_mat)==1); 
    for j=1:numel(indx_nan)
        data_mat{indx_nan(j)}=NaN; 
    end 
    
    if (type(i)==1) %ANY USE
        cocaine_mat=zeros(r-1,1);
        crack_mat=zeros(r-1,1);
        speed_mat=zeros(r-1,1);
        
        for j=1:r-1
            temp=[' ' data_mat{j} ' ']; 
            indx=strfind(temp,' 1 '); 
            if isempty(indx)==0
                cocaine_mat(j)=1; 
            end 
           
            indx=strfind(temp,' 2 '); 
            if isempty(indx)==0
                crack_mat(j)=1; 
            end 
            
            indx=strfind(temp,' 13 '); 
            if isempty(indx)==0
                speed_mat(j)=1; 
            end 
        end 
        
        indx_cocaine=find(cocaine_mat==1); 
        indx_crack=find(crack_mat==1); 
        indx_speedball=find(speed_mat==1); 
        
        %to use later! 
        indx_mat(indx_cocaine,1)=1; 
        indx_mat(indx_crack, 2)=1; 
        indx_mat(indx_speedball,3)=1; 
        
        fprintf(FILE_IN, '%s\n',  'Lifetime drug use'); 
        
        cocaine=numel(indx_cocaine)/(r-1)*100; 
        temp=['Ever used cocaine: ' num2str(numel(indx_cocaine)) ' (' num2str(sprintf('%.1f', cocaine)) '%)']; 
        fprintf(FILE_IN, '%s\n', temp); 
        
        crack=numel(indx_crack)/(r-1)*100;
        temp=['Ever used crack: ' num2str(numel(indx_crack)) ' (' num2str(sprintf('%.1f',crack)) '%)']; 
        fprintf(FILE_IN, '%s\n', temp); 
        
        speedball=numel(indx_speedball)/(r-1)*100;
        temp=['Ever used speedball: ' num2str(numel(indx_speedball)) ' (' num2str(sprintf('%.1f',speedball)) '%)']; 
        fprintf(FILE_IN, '%s\n\n', temp); 
        
    elseif (type(i)==2) %REGULAR USE
        new_mat=zeros(r-1,1); 
        
        for j=1:r-1
            temp=''; 
            x=data_mat{j}; 
            k=strfind(x,' months'); 
            k2=strfind(x, ' month'); 
            if isempty(k)==0
                k1=(k(1)-1); 
                for p_=1:k1
                    c=x(p_);
                    temp=[temp c];
                end 
                new_mat(j)=str2double(temp); 
            elseif isempty(k2)==0
                k1=(k2(1)-1); 
                for p_=1:k1
                    c=x(p_);
                    temp=[temp c];
                end 
                new_mat(j)=str2double(temp); 
            else
                new_mat(j)=x;         
            end
        end 
        
%         new_mat(new_mat==77)=NaN;
%         new_mat(new_mat==88)=NaN;
%         new_mat(new_mat==99)=NaN;


        indx_type=find(indx_mat(:,i-1)==1); %the number of people reporting ever using from above
        indx_reg=find(new_mat>0); 
        indx_reg2=find(new_mat>5); 
        indx_final=intersect(indx_type, indx_reg); 
        indx_final2=intersect(indx_type, indx_reg2); 
        reg_users=numel(indx_final); 
        all_users=numel(indx_type); 
        reg_users2=numel(indx_final2); 
        per_of_users=reg_users/all_users*100; 
        per_of_all=reg_users/(r-1)*100; 
        per_of_users2=reg_users2/all_users*100; 
        per_of_all2=reg_users2/(r-1)*100; 
        
        %those who report 6+ months to use in the analysis below
        reg_mat(i-1,indx_reg2)=1; 
        
        indx_nan=find(new_mat==0); 
        new_mat(indx_nan)=NaN; 
        mean_use=nanmean(new_mat); 
        std_use=nanstd(new_mat); 
        min_use=min(new_mat); 
        max_use=max(new_mat);
        
        %find the number who report any regular use   
        fprintf(FILE_IN, '%s\n', labels{i} ); 
        temp=['Average number of months of ' labels{i} ' ' num2str(sprintf('%.1f',mean_use)) ' (' num2str(sprintf('%.1f',std_use)) ')']; 
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Range in number of months of ' labels{i} ' ' num2str(min_use) '-' num2str(max_use)]; 
        fprintf(FILE_IN, '%s\n', temp ); 
        
        temp=['Participants with more than 1 month of ' labels{i} ' ' num2str(reg_users)];   
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all ' drugs{i-1} ' users ' num2str(sprintf('%.1f', per_of_users)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all participants ' num2str(sprintf('%.1f', per_of_all)) '%'];
        fprintf(FILE_IN, '%s\n\n', temp ); 
        
        temp=['Participants with 6 or more months of ' labels{i} ' ' num2str(reg_users2)];   
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all ' drugs{i-1} ' users ' num2str(sprintf('%.1f', per_of_users2)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all participants ' num2str(sprintf('%.1f', per_of_all2)) '%'];
        fprintf(FILE_IN, '%s\n\n', temp ); 
        
    elseif (type(i)==3) %DRUG INJECTION
        cocaine_mat2=zeros(r-1,1);
        crack_mat2=zeros(r-1,1);
        speed_mat2=zeros(r-1,1);
        
        for j=1:r-1
            temp=[' ' data_mat{j} ' ']; 
            indx=strfind(temp,' 1 '); 
            if isempty(indx)==0
                cocaine_mat2(j)=1; 
            end 
           
            indx=strfind(temp,' 2 '); 
            if isempty(indx)==0
                crack_mat2(j)=1; 
            end 
            
            indx=strfind(temp,' 11 '); 
            if isempty(indx)==0
                speed_mat2(j)=1; 
            end 
        end 
        
        indx_cocaine2=find(cocaine_mat2==1); 
        indx_crack2=find(crack_mat2==1); 
        indx_speedball2=find(speed_mat2==1); 
        
        %to use later! 
        indx_mat2(indx_cocaine2,1)=1; 
        indx_mat2(indx_crack2, 2)=1; 
        indx_mat2(indx_speedball2,3)=1; 
        
        fprintf(FILE_IN, '%s\n',  'Lifetime injected drug use'); 
        
        cocaine=numel(indx_cocaine2)/(r-1)*100; 
        temp=['Number ever injected cocaine: ' num2str(numel(indx_cocaine2)) ]; 
        fprintf(FILE_IN, '%s\n', temp); 
        indx_final=intersect(indx_cocaine2, indx_cocaine); 
        reg_users=numel(indx_final); 
        all_users=numel(indx_cocaine); 
        per_of_users=reg_users/all_users*100; 
        per_of_all=reg_users/(r-1)*100; 
        temp=['Percentage of all partipcants injected ' num2str(sprintf('%.1f', per_of_all)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage injected of all cocaine users ' num2str(sprintf('%.1f', per_of_users)) '%'];
        fprintf(FILE_IN, '%s\n\n', temp ); 
        
        crack=numel(indx_crack2)/(r-1)*100;
        temp=['Number ever injected crack: ' num2str(numel(indx_crack2))]; 
        fprintf(FILE_IN, '%s\n', temp); 
        indx_final=intersect(indx_crack2, indx_crack); 
        reg_users=numel(indx_final); 
        all_users=numel(indx_crack); 
        per_of_users=reg_users/all_users*100; 
        per_of_all=reg_users/(r-1)*100; 
        temp=['Percentage of all participants injected ' num2str(sprintf('%.1f', per_of_all)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage injected of all crack users ' num2str(sprintf('%.1f', per_of_users)) '%'];
        fprintf(FILE_IN, '%s\n\n', temp ); 
        
        
        speedball=numel(indx_speedball2)/(r-1)*100;
        temp=['Ever injected speedball: ' num2str(numel(indx_speedball2))];  
        fprintf(FILE_IN, '%s\n', temp); 
        indx_final=intersect(indx_speedball2, indx_speedball); 
        reg_users=numel(indx_final); 
        all_users=numel(indx_speedball); 
        per_of_users=reg_users/all_users*100; 
        per_of_all=reg_users/(r-1)*100; 
        temp=['Percentage of all participants injected ' num2str(sprintf('%.1f', per_of_all)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage injected of all speedball users ' num2str(sprintf('%.1f', per_of_users)) '%'];
        fprintf(FILE_IN, '%s\n\n', temp ); 
        
    elseif (type(i)==4) %REGULAR DRUG INJECTION
        
        new_mat=zeros(r-1,1); 
        
        for j=1:r-1
            temp=''; 
            x=data_mat{j}; 
            k=strfind(x,' months'); 
            k2=strfind(x, ' month'); 
            if isempty(k)==0
                k1=(k(1)-1); 
                for p_=1:k1
                    c=x(p_);
                    temp=[temp c];
                end 
                new_mat(j)=str2double(temp); 
            elseif isempty(k2)==0
                k1=(k2(1)-1); 
                for p_=1:k1
                    c=x(p_);
                    temp=[temp c];
                end 
                new_mat(j)=str2double(temp); 
            else
                new_mat(j)=x;         
            end
        end 
        
%         new_mat(new_mat==77)=NaN;
%         new_mat(new_mat==88)=NaN;
%         new_mat(new_mat==99)=NaN;
        
        indx_type=find(indx_mat(:,i-5)==1); %the number of people reporting ever using from above
        indx_reg=find(new_mat>0); 
        indx_final=intersect(indx_type, indx_reg); 
        reg_users=numel(indx_final);  
        indx_reg2=find(new_mat>5); 
        indx_final2=intersect(indx_type, indx_reg2); 
        reg_users2=numel(indx_final2); 
        
        indx_type2=find(indx_mat2(:,i-5)==1); 
        indx_final2=intersect(indx_type2, indx_reg); 
        inject_users=numel(indx_type2); 
        per_of_inject=reg_users/inject_users*100; 
        per_of_inject2=reg_users2/inject_users*100; 
        
        %those who report 6+ months to use in the analysis below
        reg_inj_mat(i-5,indx_reg2)=1; 
        
        all_users=numel(indx_type); 
        per_of_users=reg_users/all_users*100; 
        per_of_all=reg_users/(r-1)*100; 
        per_of_users2=reg_users2/all_users*100; 
        per_of_all2=reg_users2/(r-1)*100; 
        
        indx_nan=find(new_mat==0); 
        new_mat(indx_nan)=NaN; 
        mean_use=nanmean(new_mat); 
        std_use=nanstd(new_mat); 
        min_use=min(new_mat); 
        max_use=max(new_mat);
        
        %find the number who report any regular use   
        fprintf(FILE_IN, '%s\n', labels{i} ); 
        temp=['Average number of months of ' labels{i} ' ' num2str(sprintf('%.1f',mean_use)) ' (' num2str(sprintf('%.1f',std_use)) ')']; 
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Range in number of months of ' labels{i} ' ' num2str(min_use) '-' num2str(max_use)]; 
        fprintf(FILE_IN, '%s\n', temp ); 
        
        temp=['Participants with more than 1 month of ' labels{i} ' ' num2str(reg_users)]; 
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all ' drugs{i-5} ' injection users ' num2str(sprintf('%.1f', per_of_inject)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all ' drugs{i-5} ' users ' num2str(sprintf('%.1f', per_of_users)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all participants ' num2str(sprintf('%.1f', per_of_all)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        
        temp=['Participants with 6 or more months of ' labels{i} ' ' num2str(reg_users2)]; 
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all ' drugs{i-5} ' injection users ' num2str(sprintf('%.1f', per_of_inject2)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all ' drugs{i-5} ' users ' num2str(sprintf('%.1f', per_of_users2)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all participants ' num2str(sprintf('%.1f', per_of_all2)) '%'];
        fprintf(FILE_IN, '%s\n\n', temp ); 
        
    elseif type(i)==5
        
         new_mat=zeros(r-1,1); 
        
        for j=1:r-1
            temp=''; 
            x=data_mat{j}; 
            k=strfind(x,' days'); 
            k2=strfind(x, ' day'); 
            if isempty(k)==0
                k1=(k(1)-1); 
                for p_=1:k1
                    c=x(p_);
                    temp=[temp c];
                end 
                new_mat(j)=str2double(temp); 
            elseif isempty(k2)==0
                k1=(k2(1)-1); 
                for p_=1:k1
                    c=x(p_);
                    temp=[temp c];
                end 
                new_mat(j)=str2double(temp); 
            else
                new_mat(j)=x;         
            end
        end 
        
%         new_mat(new_mat==77)=NaN;
%         new_mat(new_mat==88)=NaN;
%         new_mat(new_mat==99)=NaN;
        
        indx_type=find(indx_mat(:,i-8)==1); %the number of people reporting ever using from above
        indx_reg=find(new_mat>0); 
        indx_final=intersect(indx_type, indx_reg); 
        reg_users=numel(indx_final); 
        all_users=numel(indx_type); 
        per_of_users=reg_users/all_users*100; 
        per_of_all=reg_users/(r-1)*100; 
        
        indx_nan=find(new_mat==0); 
        new_mat(indx_nan)=NaN; 
        mean_use=nanmean(new_mat); 
        std_use=nanstd(new_mat); 
        min_use=min(new_mat); 
        max_use=max(new_mat);
        
        %find the number who report any regular use  
        fprintf(FILE_IN, '%s\n', [drugs{i-8} ' use in the past 30 days'] ); 
        temp=['Participants with more than 1 day of ' labels{i} ' ' num2str(reg_users)];   
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Average number of days of ' labels{i} ' ' num2str(sprintf('%.1f',mean_use)) ' (' num2str(sprintf('%.1f',std_use)) ')']; 
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Range in number of days of ' labels{i} ' ' num2str(min_use) '-' num2str(max_use)]; 
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all ' drugs{i-8} ' users with more than 1 day of ' labels{i} ' ' num2str(sprintf('%.1f', per_of_users)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all participants with more than 1 day of ' labels{i} ' ' num2str(sprintf('%.1f', per_of_all)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        
        % Life time REGULAR use [DRUG] at least 6 months AND use in the last 30 days   
        indx_month=find(reg_mat(i-8,:)==1); 
        indx_combo=intersect(indx_month, indx_reg); 
        fprintf(FILE_IN, '%s\n', ['Participants with at least 6 months of regular ' drugs{i-8} ' use and ' drugs{i-8} ' use in the past 30 days'] ); 
        x=numel(indx_combo); 
        p=x/(r-1)*100; 
        temp=['N = ' num2str(x) ' (' num2str(sprintf('%.1f', p)) '%)']; 
        fprintf(FILE_IN, '%s\n\n', temp ); 
        
    elseif type(i)==6
        
         new_mat=zeros(r-1,1); 
        
        for j=1:r-1
            temp=''; 
            x=data_mat{j}; 
            k=strfind(x,' days'); 
            k2=strfind(x, ' day'); 
            if isempty(k)==0
                k1=(k(1)-1); 
                for p_=1:k1
                    c=x(p_);
                    temp=[temp c];
                end 
                new_mat(j)=str2double(temp); 
            elseif isempty(k2)==0
                k1=(k2(1)-1); 
                for p_=1:k1
                    c=x(p_);
                    temp=[temp c];
                end 
                new_mat(j)=str2double(temp); 
            else
                new_mat(j)=x;         
            end
        end 
        
%         new_mat(new_mat==77)=NaN;
%         new_mat(new_mat==88)=NaN;
%         new_mat(new_mat==99)=NaN;
        
        indx_type=find(indx_mat2(:,i-10)==1); %the number of people reporting ever using from above
        indx_reg=find(new_mat>0); 
        indx_final=intersect(indx_type, indx_reg); 
        reg_users=numel(indx_final); 
        all_users=numel(indx_type); 
        per_of_users=reg_users/all_users*100; 
        per_of_all=reg_users/(r-1)*100; 
        
        indx_nan=find(new_mat==0); 
        new_mat(indx_nan)=NaN; 
        mean_use=nanmean(new_mat); 
        std_use=nanstd(new_mat); 
        min_use=min(new_mat); 
        max_use=max(new_mat);
        
        %find the number who report any regular use  
        fprintf(FILE_IN, '%s\n', ['Injected ' drugs{i-10} ' use in the past 30 days'] ); 
        temp=['Participants with more than 1 day of ' labels{i} ' ' num2str(reg_users)];   
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Average number of days of ' labels{i} ' ' num2str(sprintf('%.1f',mean_use)) ' (' num2str(sprintf('%.1f',std_use)) ')']; 
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Range in number of days of ' labels{i} ' ' num2str(min_use) '-' num2str(max_use)]; 
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all ' drugs{i-10} ' injection users with more than 1 day of ' labels{i} ' ' num2str(sprintf('%.1f', per_of_users)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        temp=['Percentage of all participants with more than 1 day of ' labels{i} ' ' num2str(sprintf('%.1f', per_of_all)) '%'];
        fprintf(FILE_IN, '%s\n', temp ); 
        
         % Life time REGULAR use [DRUG] at least 6 months AND use in the last 30 days   
        indx_month=find(reg_inj_mat(i-10,:)==1); 
        indx_combo=intersect(indx_month, indx_reg); 
        fprintf(FILE_IN, '%s\n', ['Participants with at least 6 months of regular injected ' drugs{i-10} ' use and injected ' drugs{i-10} ' use in the past 30 days'] ); 
        x=numel(indx_combo); 
        p=x/(r-1)*100; 
        temp=['N = ' num2str(x) ' (' num2str(sprintf('%.1f', p)) '%)']; 
        fprintf(FILE_IN, '%s\n\n', temp ); 
        
    end
end 


fclose(FILE_IN); 
