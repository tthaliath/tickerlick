#Commented PERL shebang line as it reduces portability. You don't need PERL executable path to run this script
##!/usr/bin/perl -w
use strict;
use warnings;

#Uncomment below line to print the tree data structure
#use Data::Dumper;

#pass flat file name as command line argument
#the flat file should contain the output of unix command "ps -e l"

if (!$ARGV[0]) {
   print "Missing flat file name.\n";
   print "perl tree.pl <FLAT FILE NAME>\n";
   exit;
  }
my $flatfile = $ARGV[0];
#Store the contents of flat file to a variable.
local $/ = undef;
open(F,"<$flatfile") || die "Error opening file $flatfile: $!\n";
my ($flatfilestr) = <F>;
close(F);
$/ = 1;

my (%phash,%printed);

&process_flat_file($flatfilestr);

#for each process id, add child process, if any.
foreach my $pid ( sort {$a <=> $b} keys %phash)
{
     #skip if process id is 1.
     if ($pid == 1) {next;}
     checkParent($pid);
}

#Uncomment below line to print the tree data structure.
#print Dumper(%phash);

#Finally, create the output tree file

my ($outfile) = "treeformat.txt";
open (OUT,">$outfile");
#print heading
print OUT " PID         TTY      STAT     TIME   COMMAND\n";

foreach my $pid ( sort {$a <=> $b} keys %phash)
{
      &print_tree($pid);
}

close (OUT);

print "Output file: $outfile\n";

#END

#functions used

sub process_flat_file {
my ($ffile) = shift;

my ($f,$uid,$pid,$ppid,$pri,$ni,$vsz,$rss,$wchan,$stat,$tty,$ptime,@commandarr,$command,$pidformatted,$newline);
foreach my $line ( split (/\n/,$ffile) )
  {
    #skip header line
    if ($line =~ /\s+PPID\s+/) { next;}
    # for the tree structure, we need PPID,  PID, TTY, STAT, TIME, COMMAND 
    # F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
    # 4     0     1     0  18   0  20132  1444 stext  Ss   ?          0:39 init
       ($f,$uid,$pid,$ppid,$pri,$ni,$vsz,$rss,$wchan,$stat,$tty,$ptime,@commandarr) = split /\s+/, $line;
       $command = join(' ',@commandarr);
       $pidformatted =  sprintf("%5d", $pid);
       $tty =  sprintf("%5s", $tty);
       $stat =  sprintf("%5s", $stat);
       $ptime =  sprintf("%5s", $ptime);
       $newline = "$pidformatted     $tty     $stat     $ptime";
       $phash{$pid}{"ppid"} = $ppid;
       $phash{$pid}{"command"} = $command;
       $phash{$pid}{"newline"} = $newline;
       $phash{$pid}{"children"} = [];
       $phash{$pid}{"indentcount"} = 0;
  }

}

sub checkParent {

    my $pid = shift;
    my ($pidchild);
    #check pid is a parent of some other pid. if so, add it as  child.
    foreach $pidchild ( sort {$a <=> $b} keys %phash)
     {
         if ($pid == $phash{$pidchild}{"ppid"})
          {
             push @{$phash{$pid}{"children"}},$pidchild;
             #no. of indents of child PID should be one more than its parent.
             $phash{$pidchild}{"indentcount"} = $phash{$pid}{"indentcount"} + 1;
          } 
      } 
}

sub getIndentStr {
   my $indentcount = shift;
   if ($indentcount == 0){return ' ';}
   if ($indentcount == 1){return ' \_ ';}
   return '   ' x ($indentcount - 1).' \_ ';;
}

#This function is recursive. if a process has children, it  will call function print_tree until it processes all children.

sub print_tree {
    my $pid = shift;
    if (!$printed{$pid}) {
   	 print OUT $phash{$pid}{"newline"}.&getIndentStr($phash{$pid}{"indentcount"}).$phash{$pid}{"command"}."\n";
         $printed{$pid}++;
     }
    if ( &hasChildren($pid) > 0 ){
        foreach my $child ( sort { $a <=> $b } @{ $phash{$pid}{"children"} } ){
            &print_tree( $child );
        }
    }
}

sub hasChildren {
    my $pid = shift;
    return scalar @{ $phash{$pid}{"children"} };
}
