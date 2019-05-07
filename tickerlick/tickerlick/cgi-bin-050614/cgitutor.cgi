#!/usr/bin/perl
use lib qw(/home/tickerlick/cgi-bin);
use lib qw(/home/tickerlick/Tickermain);

print "Content-type:text/html\n\n";
use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my ($q) = new CGI;
my ($fname) = $q->param("fname");
print start_html("Environment");
my $form = '<form action=cgitutor.cgi method="POST" >
            <input type="text" name=fname>
            <input type="text" name=lname>
            <input type="submit"><input type="reset">
             </form>';
print "$form\n";

my $checkbox = '<b>Pick a Color:</b><br>

<form action="cgitutor.cgi" method="POST">
<input type="checkbox" name="color" value="red"> Red<br>
<input type="checkbox" name="color" value="green"> Green<br>
<input type="checkbox" name="color" value="blue"> Blue<br>
<input type="checkbox" name="color" value="gold"> Gold<br>
<input type="checkbox" name="color" value="black">black<br> 
<input type="submit">
</form>';
print "<table><tr><td>$fname</td><td>".$q->param('lname')."</td></tr></table>";
print "$checkbox\n";
my @colors = $q->param('color');
foreach (@colors)
{
      print "<br>$_";
}

print '<b>Pick a Color:</b><br>';

my $radio = '<form action="cgitutor.cgi" method="POST">
<input type="radio" name="color" value="red"> Red<br>
<input type="radio" name="color" value="green"> Green<br>
<input type="radio" name="color" value="blue"> Blue<br>
<input type="radio" name="color" value="gold"> Gold<br>
<input type="radio" name="color" value="orange"> Orange<br>
<input type="submit">
</form>';

print "$radio\n";
my $color = $q->param('color');
print "$color\n";
my $select = '<form action="cgitutor.cgi" method="POST">
<select name="colorsel">         
<option value="red"> Red
<option value="green"> Green
<option value="blue"> Blue
<option value="gold"> Gold
</select>
<input type="submit"></form>';

my $selectm = '<form action="cgitutor.cgi" method="POST">
<select name="colorselm" multiple size=3>
<option value="red"> Red
<option value="green"> Green
<option value="blue"> Blue
<option value="gold"> Gold
</select>
<input type="submit"></form>';
print "$select\n";
print "$selectm\n";

print "<br>".$q->param("colorsel")."\n";
my @colors = $q->param('colorselm');
foreach my $color (@colors) {
   print "You picked $color.<br>\n";
}

print end_html;

