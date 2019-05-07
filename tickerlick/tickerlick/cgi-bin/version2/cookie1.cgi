use CGI;

$q = new CGI;

print $q->header;
print $q->start_html('fffffff');
print $q->end_html;
1;

