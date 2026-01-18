#!/usr/bin/perl
use File::stat; # Used to get last modified time of file
use Time::localtime; # Used to write last modified time in human-readable format
use Digest::MD5 qw(md5_hex); # Used to determine md5sum of file
# We can either specify the text file with list of found files on the command line, or set manually in this script
# The text file should have been written out by the FindFiles.bash script
if (-f $ARGV[0]) {
    $list = $ARGV[0] ;
    print "Using file $list\n";
} else {
    $list="~/HD_image_files.txt";
}
# Open image list file, and open output csv file for writing
open(LIST, $list) or die "Could not open $list\n";
($csv=$list) =~ s/\.txt/.csv/;
open(OUT, ">$csv") or die "Could not open $csv for writing\n";

# Read each line of the input list file, then collect stats in arrays: full path, filename, filesize etc.
print "Reading input list file $list\n";
while ($fileline = <LIST>) {
    chomp $fileline;
# check that the line is a vaild file
    if (-f $fileline) {
        push (@path, $fileline); # Column one is the full path $path
        # Isolate filename from path: Remove everything up to and including the last forward-slash
        ($filename=$fileline) =~ s/.*\///; push (@name, $filename); # Column two is the filename minus path $filename
        push (@filesize, -s $fileline); #Column three is the file size
        push (@mtime, ctime(stat($fileline)->mtime)); #Column four is the last modified time
        # The following lines will obtain the md5sum of the file
        open (my $fh, '<', $fileline) or die "Can't open $fileline: $!\n";
        binmode($fh);
        $md5 = Digest::MD5->new->addfile($fh)->hexdigest;
        close($fh);
        push (@md5sum, $md5) ; # Column five is the md5sum
        #print {OUT} "$path,$filename,$filesize,$mtime,$md5sum\n"
    }
}
# Compare each md5sum value to every previous md5sum value to find duplicates
# The first one can be skipped because it has no previous values to compare with
print "Checking for duplicate md5sums\n";
$duplicate[0] = 0;
for ( $i=1 ; $i < scalar(@md5sum) ; $i++ ) {
    $duplicate[$i] = 0;
#    $comparemd5sum = $md5sum[$i];
    for ( $j=0 ; $j < $i ; $j++ ) {
        if ($md5sum[$i] eq $md5sum[$j]) {
            #print "Duplicate md5sum found: \$i=$i \$j=$j \$md5sum[\$i]=$md5sum[$i] \$md5sum[\$j]=$md5sum[$j]\n"; <STDIN>;
            $duplicate[$i] = 1
        }
    }
}
# Write out csv file
print "Writing out csv file $csv\n";
for ( $i=0 ; $i < scalar(@md5sum) ; $i++ ) {
    print {OUT} "$path[$i],$name[$i],$filesize[$i],$mtime[$i],$md5sum[$i],$duplicate[$i]\n";
}
close LIST;
close OUT;

