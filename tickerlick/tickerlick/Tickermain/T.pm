#!/usr/bin/perl -w
use strict;

package T;

sub new
{
    my $class = shift;
     my $self = {
        dmadays  => {},
    };

    bless $self, $class;
    return $self;
}

sub setdmadays
{
   my $self = shift;
   my $val = shift;
   $self->{dmadays}->{ticker} = $val;
}

sub getdmadays
{
   my $self = shift;
   return $self->{dmadays}->{ticker};
}
1;
