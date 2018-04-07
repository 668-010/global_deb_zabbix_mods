#!/usr/bin/perl

#must be run as root

$first = 1;

print "{\n";
print "\t\"data\":[\n\n";

for (`cat /etc/zabbix/global_deb_zabbix_mods/packages/packages.list`) {


    $pkg_name =$_;
    chomp($pkg_name);

print "\t,\n" if not $first;
    $first = 0;

    print "\t{\n";
    print "\t\t\"{#PKG}\":\"$pkg_name\"\n";
    print "\t}\n";

}

print "\n\t]\n";
print "}\n";