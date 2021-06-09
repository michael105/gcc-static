#!/bin/perl -w


$GCC = "gcc";
$APPENDFLAGS = "-static -Os -s";
$LDD = "ldd";
$LDCONFIG = "ldconfig -p";




#use Data::Dumper::Simple;


our @NEWARGS;
our @libs;
our %linked;
our @LIBS;



# Build a associative hash of all (dynamic) libraries
%cache = map { /^\s*lib(\S*)\.so[. ].*> (\S*)/; $1=>$2; }  
					grep { /^\s*lib.*=>/ } `$LDCONFIG`;

#print Dumper(%cache);
foreach my $arg ( @ARGV ){
	#print "arg: $arg\n";
	if ( $arg =~ /^-l(.*)/ ){
		#print "lib: $1\n";
		push @libs, $1;
	} else {
		push @NEWARGS, $arg;
	}

}


$rec=10;

sub depends{
	if ( $rec == 0 ){
		return;
	}
	$rec--;
	my $library = shift;
	if ( ! defined($cache{$library} ) ){
				print "Not found: $library\n";
			}

	my @L = `$LDD $cache{$library}`;
	#print Dumper(@L);
	my @l = grep { $_ } map { /^\s*lib(\S*)\.so/; $1 } @L;
	foreach my $link ( @l ){
		if ( $linked{$link} ){
			#print "Already linked: $link\n";
		} else {
			$linked{$link} = 1;
			#print "Link: $link\n";
			#push @NEWARGS, "-l$link";
			push @LIBS, $link;
			depends($link);
		}
	}
	$rec++;
}



foreach my $lib ( @libs ){
	#print "\nDepending on $lib\n";
	push @LIBS, $lib;
	depends( $lib );
}



my $arg = join(" ",@NEWARGS);
$arg =~ s/\"/\\\"/g;

$arg.=" -Wl,-O1,--gc-sections,--start-group";

foreach my $l ( @LIBS ){
	$arg .= " -l$l";
}

$arg.=" -Wl,--end-group $APPENDFLAGS";

print "\n$GCC $arg\n";

system("$GCC $arg");



