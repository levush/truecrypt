#!/usr/bin/perl -w
use strict;

open(OUT, ">&STDOUT") or die "Couldn't dup STDOUT: $!";
open(IN,  "<&STDIN" ) or die "Couldn't dup STDIN : $!";

print OUT ".TH TRUECRYPT 1\n";
print OUT ".SH NAME\n";
print OUT "truecrypt \\- create and mount TrueCrypt encrypted volumes\n";

my $section = "";

while(my $line = <IN>)
{
  if ($line =~ m/^([a-z_]+):$/i)
  {
    $section= lc($1);
  }

  my $out = $line;

  if ($line =~ m/^[a-z_]+:$/i)
  {
    $line =~ s/://;
    $line = ".SH " . $line;

    $out = uc($line);
  }
  elsif ($section eq "synopsis")
  {
    $line =~ s/([A-Z_]+)/\\fI$1\\fP/g;
    $out = $line."\n";
  }
  elsif ($section eq "examples")
  {
    if ($line =~ m/^.*:$/)
    {
      $out = ".PP\n.B $line";
    }
    elsif ($line =~ m/.+/)
    {
      $out = ".nf\n$line.fi\n";
    }
  }
  elsif ($line =~ m/^-/)
  {
    $out = ".TP\n.B ".$line;
  }

  # In general, the hyphen-minus is meant to be a minus.
  $out =~ s/-/\\-/g;
  print OUT $out
}

print OUT ".SH COPYRIGHT\n";
print OUT "TrueCrypt is \\(co 2012 TrueCrypt Developers Association. All rights reserved.\n";

print OUT ".PP\nThis manual page was automatically generated from the output of \\fBtruecrypt \\-\\-help\\fP\n";
print OUT "as part of unofficial TrueCrypt Debian packaging from\n";
print OUT "\\fIhttp://www.unchartedbackwaters.co.uk/pyblosxom/static/truecrypt_debian_packaging\\fP.\n";

close(IN);
close(OUT);
