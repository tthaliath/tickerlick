
#!/usr/bin/perl

  


# PERL MODULES WE WILL BE USING 


use CGI; 


use DBI; 


use DBD::mysql; 


use JSON; 


  


# HTTP HEADER 


print "Content-type: application/json; charset=iso-8859-1\n\n"; 


  


# CONFIG VARIABLES 


my $platform = "mysql"; 


my $database = "YOUR_DB_NAME"; 


my $host = "localhost"; 


my $port = "3306"; 


my $tablename = "YOUR_TABLE_NAME"; 


my $user = "YOUR_USER_NAME"; 


my $pw = "YOUR_DB_PW"; 


my $cgi = CGI->new(); 


my $term = $cgi->param('term'); 


  


# DATA SOURCE NAME 


$dsn = "dbi:mysql:$database:localhost:3306"; 


# PERL DBI CONNECT 


$connect = DBI->connect($dsn, $user, $pw); 


  


# PREPARE THE QUERY 


$query_handle = $connect->prepare(qq{select id, trim(both char(13) from state) AS value, abbrev FROM states where state like ?;}); 


  


# EXECUTE THE QUERY 


$query_handle->execute('%'.$term.'%'); 


  


# LOOP THROUGH RESULTS 


while ( my $row = $query_handle->fetchrow_hashref ){ 


    push @query_output, $row; 


}  


# CLOSE THE DATABASE CONNECTION 


$connect->disconnect(); 


  


# JSON OUTPUT 


print JSON::to_json(\@query_output); 

