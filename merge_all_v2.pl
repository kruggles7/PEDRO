#/usr/bin/perl -w

use strict;
my %new_id=('SEED100'=>100, 'SEED101'=>101, 'SEED102'=>102, 10=>1076, 1976=>1076);
my %exclude=(1099=>1, 1126=>1, 1128=>1, 1142=>1, 1239=>1, 1280=>1, 1273=>1, 1300=>1, 1309=>1, 1310=>1, 1316=>1, 1331=>1, 1189=>1); 
my $dir=".";
my %data=(); 
my %headers=();
my %ids=();  
my $tcga_count=0; 
my $header_number=0;
my %header_order=();
my %blank_samples=();
my %blank_questions=();


if (opendir(dir,"$dir"))
{
	my @allfolders=readdir dir; 
	close dir; 
	foreach my $folder (@allfolders)
	{
		if ($folder=~/^set/)
		{
			if (opendir(DIR,"$dir/$folder"))
			{
				my @allfiles=readdir DIR;
				closedir DIR;
				foreach my $file (@allfiles)
				{
					if ($file=~/^Pedro_merge/ && $file=~/\.txt$/)
					{
						open (IN, "<$dir/$folder/$file") or die "can't open file";
						my $line=<IN>;
						my @header=split('\t', $line);
						while ($line=<IN>)
						{
							chomp($line);
							if ($line=~/^([^\t]*)\t(.*)/)
							{
								my $id=$1; 
								my $data=$2; 
								$id=~s/number//;
								$id=~s/#//;
								$id=uc($id);
								$id=~ s/\s+//g;
								if ($new_id{$id}=~/\w/)
								{
									$id=$new_id{$id}; 
								}
								$ids{$id}=1; 
								my @data=split('\t', $data); 
								my $n=scalar(@data);
								for (my $i=0; $i<$n; $i++)
								{
									my $temp_data=$data[$i]; 
									my $head=$header[$i+1];
									if ($temp_data!~/\w/)
									{
										$temp_data="NaN";
										$blank_samples{$id}++;
										$blank_questions{$head}++; 
									}
									$data{"$id-$head"}=$temp_data; 
									$headers{$head}=1;
									$header_order{$i}=$head; 
								}
							}
						}
					}
				}
			}
		}
	}
}

open (OUT, ">pedro_merge_final.txt") or die "can't open file";
open (FILTER, ">pedro_merge_final_filtered.txt") or die "can't open file";
print OUT "ID\t";
print FILTER "ID\t"; 
foreach my $key(sort keys %header_order)
{
	print OUT "$header_order{$key}\t";
	print FILTER "$header_order{$key}\t";
}
print OUT "\n";
print FILTER "\n"; 

foreach my $id (keys %ids)
{
	print OUT "$id\t";
	if ($exclude{$id} ne 1)
	{
		print FILTER "$id\t"; 
	}
	foreach my $key (sort keys %header_order)
	{
		my $head=$header_order{$key}; 
		if ($data{"$id-$head"}=~/\w/)
		{
			my $temp=$data{"$id-$head"}; 
			#clean up the data!!
			#$temp=uc($temp);
			#$temp=~s/\$//g; 
			#$temp=~s/DAYS//g; 
			#$temp=~s/DAY//g; 
			#$temp=~s/BAGS//g; 
			#$temp=~s/MG//g; 
			#$temp=~s/MONTHS//g; 
			#$temp=~s/MONTH//g; 
			#$temp=~s/YEARS//g; 
			#$temp=~s/YEAR//g; 
			#$temp=~s/#//;
			#$temp=~s/DOLLARS//;
			#$temp=~s/OUNCE/OZ/;
			#$temp=~s/OUNCES/OZ/;
			#$temp=~s/GRAM/G/;
			#$temp=~s/POUND/LB/;
			#$temp=~s/POUNDS/LB/;
			print OUT "$temp\t"; 
			if ($exclude{$id} ne 1)
			{
				print FILTER "$temp\t"; 
			}
		}
		else 
		{
			print OUT "\t"; 
			if ($exclude{$id} ne 1)
			{
				print FILTER "\t"; 
			}
		}
	}
	print OUT "\n";  
	if ($exclude{$id} ne 1)
	{
		print FILTER "\n"; 
	}
}
close OUT;

open (OUT, ">sample_blanks.txt") or die "can't open file";
print OUT "ID\t#blanks\n"; 
foreach my $key (keys %blank_samples)
{
	print OUT "$key\t$blank_samples{$key}\n"; 
}
close OUT; 

open (OUT, ">question_blanks.txt") or die "can't open file";
print OUT "Header\t#blanks\n";
foreach my $key (keys %blank_questions)
{
	print OUT "$key\t$blank_questions{$key}\n"; 
}
close OUT; 