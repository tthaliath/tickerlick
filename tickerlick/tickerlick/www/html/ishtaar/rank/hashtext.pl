#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: hashtest.pl

my %aa = (
			acc =>  {
			     acckvm => 'accvalues',
				 accpsw => 'accvalues',
				 acccon => 'accvalues',
				 accfnt => 'accvalues',
				 accpcs => 'accvalues',
				 acccln => 'accvalues',
				 acctte => 'accvalues',
			},
			bok => {
				bokbus =>'bokvalues',
				bokcer =>'bokvalues',
				bokapp =>'bokvalues',
				bokdbs =>'bokvalues',
				bokpgm =>'bokvalues',
                                bokiwt =>'bokvalues',				
                                bokosn =>'bokvalues',				
                                bokmst =>'bokvalues',
			},
);

my %res,$key1;
foreach $key(keys (%aa))
  {
     $datatype = ref $aa{$key};
     print "$datatype\n";
     %res = %{$aa{$key}};
     foreach $key1(keys(%res)){print "$key1\t$res{$key1}\n";}
 }

my %bb = (
	   
	   arrays=>{
		    acc=>[
			  'acckvm',
			  'accpsw',
			  'etc. . '
			 ],
		    bok=>[
			  'bokbus',
			  'bokiwn',
			  'etc. . '
			 ]
		   }
	  );

foreach (
