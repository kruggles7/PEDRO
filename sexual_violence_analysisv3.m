load filtered_db_2015_02_24
load GENDER
%also load some deomgraphic analysis !

%2.  SEXUAL VIOLENCE/EXCHANGE VARIABLES

%%--these first variables are in the "exchange" and "exchange_N" variables

% % for total N for all variables; frequencies, percentages and p-values
% % for all variables by gender.
% % Touched/rubbed in sexual way (sexvio_Note1/sexvio_1) ? this looks correct (binary)
% % Touched/rubbed in sexual way # of times (sexvio_Note1/sexvio_2) ? this looks correct (continuous)
% % Collapse into 3 groups: 1, 2-4, 5 or more 
% % 
% % Fingers/objects inserted  (sexvio_Note1/sexvio_3) ? this looks correct (binary)
% % Fingers/objects inserted # of times (sexvio_Note1/sexvio_4) ? this looks correct (continuous)
% % Collapse into 3 groups: 1, 2-4, 5 or more
% % 
% % Sex without consent (sexvio_Note1/sexvio_5) ? this looks correct (binary)
% % Sex without consent # of times (sexvio_Note1/sexvio_6) ? this looks correct (continuous)
% % Collapse into 3 groups: 1, 2-4, 5 or more
% % 
% % Felt sex expected because using together (sexvio_Note1/sexvio_9) ? this looks correct (binary)
% % Felt sex expected because using together # of times (sexvio_Note1/sexvio_10) ? this looks correct (continuous), Collapse into 3 groups: 1-4, 5-9, 10 or more
% % Sexually insulted (sexvio_Note1/sexvio_11) ? this looks correct (binary)
% % Sexually insulted # of times (sexvio_Note1/sexvio_12) ? this looks correct (continuous),
% % Collapse into 3 groups: 1-4, 5-9, 10 or more
% % 
% % Offered drugs/$ for sex (sexvio_Note1/sexvio_13) ? this looks correct (binary)
% % Offered drugs/$ for sex # of times (sexvio_Note1/sexvio_14) ? this looks correct (continuous),
% % Frequency & % for following groups: 1-4, 5-9, 10 or more, 50 or more

% % Felt sexually violated but don't remember (sexvio_Note1/sexvio_15) ? this looks correct (binary)
% %

% % Witnessed sexual violence? this looks correct (binary, as TRUE/FALSE right now)
% % sexvio_Note1/sexvio_16/1 -- witnessed someone touching/rubbing in a
% sexual way
% % sexvio_Note1/sexvio_16/2 --witnessed oral sex without consent
% % sexvio_Note1/sexvio_16/3 --witnessed finger/object insertion
% % sexvio_Note1/sexvio_16/4 -- witnessed sex without consent
% % sexvio_Note1/sexvio_16/88 --Don't know <----DON'T DO THIS
% % 
% % Sexual exchange (LifetimeSex_3) ? this looks correct (binary)
% % Sexual exchange received drugs/$ # times (LifetimeSex_4) ? this looks correct (continuous)
% % Collapse into 3 groups: 1, 2-4, 5 or more
% % 
% % Sexual exchange paid drugs/$ # times (LifetimeSex_5) ? this looks correct (continuous)
% % Collapse into 3 groups: 1, 2-4, 5 or more
% % 

sex_exchanged={'LifetimeSex_3', 'LifetimeSex_4', 'LifetimeSex_5'}; 
%THE LIFETIME 5 doesn't have an intital binary

names={'Touched/rubbed in sexual way', 'Fingers/objects inserted', 'Sex without consent', 'Felt sex expected because using together', 'Sexually insulted', 'Offered drugs/$ for sex', 'Felt sexually violated but does not remember', 'Witnessed someone touching/rubbing in sexual way', 'Witnessed oral sex without consent', 'Witnessed finger/object insertion', 'Witnessed sex without consent' 'Sexual exchange received drugs/$', 'Sexual exchange paid drugs/$' }; 
exchange={'sexvio_Note1/sexvio_1','sexvio_Note1/sexvio_3', 'sexvio_Note1/sexvio_5', 'sexvio_Note1/sexvio_9','sexvio_Note1/sexvio_11', 'sexvio_Note1/sexvio_13', 'sexvio_Note1/sexvio_15', 'sexvio_Note1/sexvio_16/1', 'sexvio_Note1/sexvio_16/2', 'sexvio_Note1/sexvio_16/3', 'sexvio_Note1/sexvio_16/4', 'LifetimeSex_3', 'LifetimeSex_3'}; 
exchange_N={'sexvio_Note1/sexvio_2','sexvio_Note1/sexvio_4','sexvio_Note1/sexvio_6', 'sexvio_Note1/sexvio_10','sexvio_Note1/sexvio_12','sexvio_Note1/sexvio_14', '', '', '', '', '',  'LifetimeSex_4', 'LifetimeSex_5' }; 

[r,c]=size(filtered_final); 
filtered_data=filtered_final(2:r,:); 
headers=filtered_final(1,:); 
results=cell.empty; 
results{1,1}='Question'; 
results{1,2}='Code'; 
results{1,3}='freq-total'; 
results{1,4}='% total'; 
results{1,5}='95% CI'; 
results{1,6}='freq-males';
results{1,7}='% males'; 
results{1,8}='95% CI'; 
results{1,9}='freq-females'; 
results{1,10}='% females'; 
results{1,11}='95% CI'; 
results{1,12}='p value'; 

T={'1', '2-4', '5-9', '10-50' '>50', '1 %', '2-4 %', '5-9 %', '10-50 %', '>50 %', '1', '2-4', '5-9', '10-50' '>50', '1 %', '2-4 %', '5-9 %', '10-50 %', '>50 %', '1', '2-4', '5-9', '10-50' '>50', '1 %', '2-4 %', '5-9 %', '10-50 %', '>50 %'}; 
results(1, 12:41)=T;  

z=1.96;
for i=1:numel(exchange)
    E=exchange{i}; 
    indx=find(strcmp(headers,E)==1); 
    results{i+1,1}=names{i}; 
    E_N=exchange_N{i}; 
    indx_N=find(strcmp(headers,E_N)==1); 
    n_check=0; 

    if numel(indx)==1
        data_mat=filtered_data(:,indx); 
        indx_nan=find(strcmp('NaN', data_mat)==1); 
        for j=1:numel(indx_nan)
            data_mat{indx_nan(j)}=NaN; 
        end 
        tf=isa(data_mat,'cell');  
        indx_t=find(strcmp('TRUE',data_mat)==1); 
        if numel(indx_t)>0%tf==1
            data_mat2=NaN(size(data_mat)); 
            indx_t=find(strcmp('TRUE',data_mat)==1);  
            indx_f=find(strcmp('FALSE',data_mat)==1); 
            for j=1:numel(indx_t)
                data_mat2(indx_t(j))=1; 
            end 
            for j=1:numel(indx_f)
                data_mat2(indx_f(j))=0; 
            end 
%             indx_empty=cellfun('isempty',data_mat); 
%             data_mat{indx_empty}=NaN; 
%             indx_nan=find(strcmp('NaN',data_mat)==1); 
%             for j=1:numel(indx_nan)
%                 data_mat{indx_nan(j)}=NaN;
%             end 
%             isnum = cellfun(@isnumeric,data_mat);
%             data_mat2 = NaN(size(data_mat));
%             data_mat2(isnum) = [data_mat{isnum}];
             data_mat=data_mat2; 
              
        else
            data_mat=cell2mat(data_mat); 
        end 
        indx_male=find(GENDER==1); 
        indx_female=find(GENDER==2); 
        data_=find(isnan(data_mat)==0);
        if numel(indx_N)==1
            results{i+1,2}=[E '-' E_N]; 
            data_n=filtered_data(:,indx_N); 
            indx_nan=find(strcmp('NaN', data_n)==1); 
            for j=1:numel(indx_nan)
                data_n{indx_nan(j)}=NaN; 
            end 
            data_n=cell2mat(data_n); 
            n_check=1; 
        else
            results{i+1,2}=E; 
        end 
        
        %TOTAL------------------------------
        N=numel(data_); %total answered
        N_m=numel(intersect(data_,indx_male)); 
        N_f=numel(intersect(data_,indx_female)); 
        if (n_check==1)
            indx_yes=find(data_mat==1 & data_n>0); 
        else 
            indx_yes=find(data_mat==1); 
        end 
        results{i+1,3}=numel(indx_yes); 
        P=numel(indx_yes)/N; 
        upper=((P+z*sqrt(P*(1-P)/N))*100); 
        lower=((P-z*sqrt(P*(1-P)/N))*100) ;
        p=P*100; 
        results{i+1,4}=[sprintf('%0.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results{i+1,5}=[lower '%-' upper '%']; 
        %Deal with the N
        if n_check==1
            indx_N=find(data_n>0); 
            indx_1=find (data_n==1); 
            indx_2=find(data_n>1 & data_n<5); 
            indx_5=find(data_n>4 & data_n<10); 
            indx_10=find(data_n>9 & data_n<50);
            indx_50=find(data_n>49); 
            results{i+1,12}=numel(indx_1); 
            results{i+1,13}=numel(indx_2);
            results{i+1,14}=numel(indx_5); 
            results{i+1,15}=numel(indx_10); 
            results{i+1,16}=numel(indx_50); 
            p_1=numel(indx_1)/numel(indx_N)*100; 
            p_2=numel(indx_2)/numel(indx_N)*100; 
            p_5=numel(indx_5)/numel(indx_N)*100; 
            p_10=numel(indx_10)/numel(indx_N)*100; 
            p_50=numel(indx_50)/numel(indx_N)*100; 
            results{i+1,17}=[sprintf('%.1f',p_1) '%']; 
            results{i+1,18}=[sprintf('%.1f',p_2) '%'];
            results{i+1,19}=[sprintf('%.1f',p_5) '%'];
            results{i+1,20}=[sprintf('%.1f',p_10) '%'];
            results{i+1,21}=[sprintf('%.1f',p_50) '%'];
        end 
      
        
        %MALE-------------------------------
        indx_M=intersect(indx_male,indx_yes); 
        results{i+1,6}=numel(indx_M); 
        P=numel(indx_M)/N_m; 
        upper=((P+z*sqrt(P*(1-P)/N_m))*100); 
        lower=((P-z*sqrt(P*(1-P)/N_m))*100) ;
        p=P*100; 
        results{i+1,7}=[sprintf('%0.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results{i+1,8}=[lower '%-' upper '%']; 
        if n_check==1
            indx_M_N=intersect(indx_male,indx_N); 
            indx_1=find (data_n==1); 
            indx_2=find(data_n>1 & data_n<5); 
            indx_5=find(data_n>4 & data_n<10); 
            indx_10=find(data_n>9 & data_n<50);
            indx_50=find(data_n>49); 
            indx_1_=intersect(indx_1,indx_male); 
            indx_2_=intersect(indx_2,indx_male); 
            indx_5_=intersect(indx_5,indx_male); 
            indx_10_=intersect(indx_10,indx_male); 
            indx_50_=intersect(indx_50, indx_male); 
            results{i+1,22}=numel(indx_1_); 
            results{i+1,23}=numel(indx_2_); 
            results{i+1,24}=numel(indx_5_); 
            results{i+1,25}=numel(indx_10_); 
            results{i+1,26}=numel(indx_50_); 
            p_1=numel(indx_1_)/numel(indx_M_N)*100;
            p_2=numel(indx_2_)/numel(indx_M_N)*100; 
            p_5=numel(indx_5_)/numel(indx_M_N)*100; 
            p_10=numel(indx_10_)/numel(indx_M_N)*100;
            p_50=numel(indx_50_)/numel(indx_M_N)*100;
            results{i+1,27}=[sprintf('%.1f',p_1) '%']; 
            results{i+1,28}=[sprintf('%.1f',p_2) '%'];
            results{i+1,29}=[sprintf('%.1f',p_5) '%'];
            results{i+1,30}=[sprintf('%.1f',p_10) '%'];
            results{i+1,31}=[sprintf('%.1f',p_50) '%'];
        end 
        
        indx_F=intersect(indx_female,indx_yes); 
        results{i+1,9}=numel(indx_F); 
        P=numel(indx_F)/N_f; 
        upper=((P+z*sqrt(P*(1-P)/N_f))*100); 
        lower=((P-z*sqrt(P*(1-P)/N_f))*100) ;
        p=P*100; 
        results{i+1,10}=[sprintf('%.1f',p) '%']; 
        upper=sprintf('%0.1f',round(upper*10)/10);
        lower=sprintf('%0.1f',round(lower*10)/10);
        results{i+1,11}=[lower '%-' upper '%']; 
        if n_check==1
            indx_F_N=intersect(indx_female,indx_N); 
            indx_1=find (data_n==1); 
            indx_2=find(data_n>1 & data_n<5); 
            indx_5=find(data_n>4 & data_n<10); 
            indx_10=find(data_n>9  & data_n<50);
            indx_50=find(data_n>49); 
            indx_1_=intersect(indx_1,indx_female); 
            indx_2_=intersect(indx_2,indx_female); 
            indx_5_=intersect(indx_5,indx_female); 
            indx_10_=intersect(indx_10,indx_female); 
            indx_50_=intersect(indx_50, indx_female); 
            results{i+1,32}=numel(indx_1_); 
            results{i+1,33}=numel(indx_2_); 
            results{i+1,34}=numel(indx_5_); 
            results{i+1,35}=numel(indx_10_); 
            results{i+1,36}=numel(indx_50_); 
            p_1=numel(indx_1_)/numel(indx_F_N)*100;
            p_2=numel(indx_2_)/numel(indx_F_N)*100; 
            p_5=numel(indx_5_)/numel(indx_F_N)*100; 
            p_10=numel(indx_10_)/numel(indx_F_N)*100;
            p_50=numel(indx_50_)/numel(indx_F_N)*100;
            results{i+1,37}=[sprintf('%.1f',p_1) '%']; 
            results{i+1,38}=[sprintf('%.1f',p_2) '%']; 
            results{i+1,39}=[sprintf('%.1f',p_5) '%'];  
            results{i+1,40}=[sprintf('%.1f',p_10) '%'];  
            results{i+1,41}=[sprintf('%.1f',p_50) '%'];  
        end 
        
        x=max(numel(indx_male),numel(indx_female)); 
        stat_mat=nan(x,2); 
        stat_mat(1:numel(indx_male),1)=zeros(numel(indx_male),1);
        stat_mat(1:numel(indx_female),2)=zeros(numel(indx_female),1);  
        stat_mat(1:numel(indx_M),1)=ones(1,numel(indx_M)); 
        stat_mat(1:numel(indx_F),2)=ones(1,numel(indx_F)); 
        [h,p]=ttest2(stat_mat(:,1), stat_mat(:,2)); 
        results{i+1,42}=p; 
    else
        E
    end 
end 
