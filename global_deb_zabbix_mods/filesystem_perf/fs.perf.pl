#!/usr/bin/perl

#must be run as root

$first = 1;

print "{\n";
print "\t\"data\":[\n\n";

for (`ls -l /dev/disk/by-id/ | cut -d"/" -f3 | sort -n | uniq`) {

    #next when total 0 at output
    if ($_ eq "total 0\n") {
        next;
    }

    print "\t,\n" if not $first;
    $first = 0;

    $disk =$_;
    chomp($disk);

    print "\t{\n";
    print "\t\t\"{#DISKNAME}\":\"$disk\"\n";
    print "\t}\n";

}

print "\n\t]\n";
print "}\n";