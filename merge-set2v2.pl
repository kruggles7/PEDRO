#/usr/bin/perl -w

use strict;
##CLINICAL DATA
my %final_id=();
my %new_id=('SEED100'=>100, 'SEED101'=>101, 'SEED102'=>102, 10=>1076, 1976=>1076);
my %all_id=(); 
my $file="../clinical/SCREENING.txt";
my %screening=();
open (IN, "$file") or die "can't open file";
my $line=<IN>;
chomp ($line);
my $screen_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]+)\t(.*)/)
    {
        my $id=$1;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $screening{$id}=$line;
        $all_id{$id}=1;
    }
    else {print "error parsing $line\n";}
}
close IN;

#STI TESTS
$file="../clinical/STI.txt";
my %sti=();
open (IN, "$file") or die "can't open file";
$line=<IN>;
chomp ($line);
my $sti_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]+)\t(.*)/) ##13 columns 
    {
        my $id=$1;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $sti{$id}=$line;
        $all_id{$id}=1;
    }
    else {print "error parsing $line\n";}
}
close IN;

#URINE TESTS
$file="../clinical/URINE.txt";
my %urine=();
open (IN, "$file") or die "can't open file";
$line=<IN>;
chomp ($line);
my $urine_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]+)\t(.*)/) ##12 columns 
    {
        my $id=$1;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $urine{$id}=$line;
        $all_id{$id}=1;
    }
    else {print "error parsing $line\n";}
}
close IN;

#HIV
$file="../clinical/HIV_HCV.txt";
my %hiv=();
open (IN, "$file") or die "can't open file";
$line=<IN>;
chomp ($line);
my $hiv_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]+)\t(.*)/) ##11 columns 
    {
        my $id=$1;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $hiv{$id}=$line;
        $all_id{$id}=1; 
    }
    else {print "error parsing $line\n";}
}
close IN;

#hair TESTS
$file="../clinical/HAIR.txt";
my %hair=();
open (IN, "$file") or die "can't open file";
$line=<IN>; 
chomp ($line);
my $hair_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]+)\t(.*)/) ##90 columns 
    {
        my $id=$1;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $hair{$id}=$line;
        $all_id{$id}=1; 
    }
    else {print "error parsing $line\n";}
}
close IN;


#FILE1 
my $file="Part1_071514Final_2014_09_03_13_01_24 (2).txt";
my %file1=();
open (IN, "$file") or die "can't open file";
my $line=<IN>;
chomp ($line);
my $file1_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]*)\t([^\t]*)\t([^\t]*)\t(.*)/) ##430 columns 
    {
        my $id=$3;
        $id=~s/number//;
        $id=~s/#//;
        $id=uc($id);
        $id=~ s/\s+//g;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $file1{$id}=$line;
        $all_id{$id}=1; 
        $final_id{$id}=1; 
    }
    else {print "error parsing $line\n";}
}
close IN;

$file="part2_071514Final_2014_09_03_13_05_18.txt";
my %file2=();
open (IN, "$file") or die "can't open file";
$line=<IN>;
chomp ($line);
my $file2_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]+)\t(.*)/) ##568 columns
    {
        my $id=$1;
        $id=~s/number//;
        $id=~s/#//;
        $id=uc($id);
        $id=~ s/\s+//g;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $file2{$id}=$line; 
        $all_id{$id}=1; 
        $final_id{$id}=1; 
    }
    else {print "error parsing $line\n";}
}
close IN;

$file="part3_071514Final_2014_09_03_13_06_13.txt";
my %file3=();
open (IN, "$file") or die "can't open file";
$line=<IN>;
chomp ($line);
my $file3_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]+)\t(.*)/) #462 columns 
    {
        my $id=$1;
        $id=~s/number//;
        $id=~s/#//;
        $id=uc($id);
        $id=~ s/\s+//g;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $file3{$id}=$line; 
        $all_id{$id}=1; 
        $final_id{$id}=1; 
    }
    else {print "error parsing $line\n";}
}
close IN;

$file="part4_071514Final_2014_08_24_19_08_54.txt";
my %file4=();
open (IN, "$file") or die "can't open file";
$line=<IN>;
chomp ($line);
my $file4_label=$line; 
while ($line=<IN>)
{
    chomp ($line);
    if ($line=~/^([^\t]+)\t(.*)/) #563 columns
    {
        my $id=$1;
        $id=~s/number//;
        $id=~s/#//;
        $id=uc($id);
        $id=~ s/\s+//g;
        if ($new_id{$id}=~/\w/){$id=$new_id{$id};}
        $file4{$id}=$line; 
        $all_id{$id}=1;
        $final_id{$id}=1; 
    }
    else {print "error parsing $line\n";}
}
close IN;

open (OUT, ">Pedro_merge_set2.txt") or die "can't open file";
#print labels
print OUT "ID\t";
my @screen_label=split('\t',$screen_label);
my $n=scalar(@screen_label);
my $c1=0;
my $c2=0;
my $c3=0;
my $c4=0;
my $c5=0;
my $c6=0;
my $c7=0;
my $c8=0;
my $c9=0;

for (my $i=0; $i<$n; $i++)
{
    print OUT "screen: $screen_label[$i]\t";
    $c1++; 
}

my @sti_label=split('\t',$sti_label);
$n=scalar(@sti_label); 
for (my $i=0; $i<$n; $i++)
{
    print OUT "sti: $sti_label[$i]\t";
    $c2++; 
}

my @urine_label=split('\t',$urine_label);
$n=scalar(@urine_label); 
for (my $i=0; $i<$n; $i++)
{
    print OUT "urine: $urine_label[$i]\t";
    $c3++; 
}

my @hiv_label=split('\t',$hiv_label);
$n=scalar(@hiv_label); 
for (my $i=0; $i<$n; $i++)
{
    print OUT "hiv_hcv: $hiv_label[$i]\t";
    $c4++; 
}

my @hair_label=split('\t',$hair_label);
$n=scalar(@hair_label); 
for (my $i=0; $i<$n; $i++)
{
    print OUT "hair: $hair_label[$i]\t";
    $c5++; 
}

my @file1_label=split('\t',$file1_label);
$n=scalar(@file1_label); 
for (my $i=0; $i<$n; $i++)
{
    print OUT "$file1_label[$i]\t";
    $c6++; 
}

my @file2_label=split('\t',$file2_label);
$n=scalar(@file2_label); 
for (my $i=0; $i<$n; $i++)
{
    print OUT "$file2_label[$i]\t";
    $c7++; 
}

my @file3_label=split('\t',$file3_label);
$n=scalar(@file3_label); 
for (my $i=0; $i<$n; $i++)
{
    print OUT "$file3_label[$i]\t";
    $c8++; 
}

my @file4_label=split('\t',$file4_label);
$n=scalar(@file4_label); 
for (my $i=0; $i<$n; $i++)
{
    print OUT "$file4_label[$i]\t";
    $c9++; 
}
print OUT "\n";

foreach my $key (keys %final_id)
{
    print OUT "$key\t";
     #screening
    if ($screening{$key}=~/\w/)
    {
        print OUT "$screening{$key}\t";
    }
    else
    { 
        for (1..$c1){print OUT "\t"; }
    }
    #sti
    if ($sti{$key}=~/\w/)
    {
        print OUT "$sti{$key}\t";
    }
    else
    {
        for (1..$c2){print OUT "\t";}
    }
    #urine
    if ($urine{$key}=~/\w/)
    {
        print OUT "$urine{$key}\t";
    }
    else
    {
        for (1..$c3){print OUT "\t"; }
    }
    #hiv
    if ($hiv{$key}=~/\w/)
    {
        print OUT "$hiv{$key}\t";
    }
    else
    {
        for (1..$c4){print OUT "\t";}
    }
    #hair tests
    if ($hair{$key}=~/\w/)
    {
        print OUT "$hair{$key}\t";
    }
    else
    {
        for (1..$c5){print OUT "\t";}
    }
    
    #file1
    if ($file1{$key}=~/\w/)
    {
        print OUT "$file1{$key}\t";
    }
    else
    {
        for (1..$c6) { print OUT "\t"; }
    }
    #file 2
    if ($file2{$key}=~/\w/)
    {
        print OUT "$file2{$key}\t";
    }
    else
    {
        for (1..$c7) { print OUT "\t"; }
    }
    
    #file 3
    if ($file3{$key}=~/\w/)
    {
        print OUT "$file3{$key}\t";
    }
    else
    {
        for (1..$c8) { print OUT "\t"; }
    }
    
    #file 4
    if ($file4{$key}=~/\w/)
    {
        print OUT "$file4{$key}\n";
    }
    else
    {
        for (1..$c9) { print OUT "\t"; }
        print OUT "\n";
    }
}
close OUT;
