use Date::Calc qw(Day_of_Week);
&marketlive;
sub  marketlive()
{
 my ($sec,$min,$hr,$day,$month,$yr19,@rest) =  localtime(time);
  my ($today) = ($yr19+1900).($month+1).$day;
 $dow = Day_of_Week(($yr19+1900),($month+1),$day);
 print "$dow,$hr,$min,$today\n";
 #if ($holihash{$today}) {return 0;}
 if ($dow >= 6){return 0;}
 if ($hr >= 7){return 1;}
 if ($hr == 6 && $min >= 30){return 1;}
 return 0;
}
