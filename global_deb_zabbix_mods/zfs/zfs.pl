#!/usr/bin/perl
$zfsexist=`df -h`;

sub zfsstat {
if (grep{/rpool/} $zfsexist )
{
    $zfsstat=`zpool status -x`;
    if (grep{/all pools are healthy/} $zfsstat) {print "1"}
        else {print "0"}
}
else {print "1"}
}



sub zfsmax {
if (grep{/rpool/} $zfsexist )
{
    $zfsmax=`grep c_max /proc/spl/kstat/zfs/arcstats | awk '{print $3}'`;
    if ($zfsmax > 2147483648) {print "0"}
        else {print "1"}
}
else {print "1"}
}

$param=@ARGV[0];
if ( $param eq "zfsmax" )                               {zfsmax();exit 0;}
if ( $param eq "zfsstat" )                              {zfsstat();exit 0;}
