$str = 'Extracts a substring out of EXPR and returns it. First character is at offset 0, or whatever you ve set  to. If OFFSET is negative, starts that far from the end of the string. If LEN is omitted, returns everything to the end of the string. You can use the substr() function as an lvalue, in which case EXPR must be an lvalue. If you assign something shorter than LEN, the string will shrink, and if you assign something longer than LEN, the string will grow to accommodate it. To keep the string the same length you may need to pad or chop your value using sprintf()';
if ($str =~ /\b(len)\b/i)
{

   print "$`\n\n";
   $l = reverse($`);
   $lstr = substr($l,0,index($l," ",30));
   $lstr = reverse($lstr);
   $rstr = substr($',0,index($'," ",30));
   print "$lstr\n\n";
   print "$rstr\n\n";
   print "...$lstr$1$rstr...\n";
}
1;
