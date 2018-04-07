#!/usr/bin/perl

#must be run as root

$first = 1;

print "{\n";
print "\t\"data\":[\n\n";

for (`ls -1 /etc/pve/qemu-server | grep .*.conf\$ | cut -d '.' -f1`) {


    print "\t,\n" if not $first;
    $first = 0;

    $vmid =$_;
    chomp($vmid);

    print "\t{\n";
    print "\t\t\"{#VMID}\":\"$vmid\"\n";
    print "\t}\n";

}

print "\n\t]\n";
print "}\n";