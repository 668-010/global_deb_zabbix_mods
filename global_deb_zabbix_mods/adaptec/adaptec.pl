#!/usr/bin/perl

sub disksdata {
@data=` /usr/StorMan/arcconf list `;
$ctrl_count=@data[0];
$ctrl_count=~/([0-9]+)/;
$ctrl_count=$1;
@result="";
$list="";


for($i = 1; $i <= $ctrl_count; $i++) {

@data=` /usr/StorMan/arcconf getconfig $1 PD `;
@smart=` /usr/StorMan/arcconf GETSMARTSTATS $1 `;
@disks=(grep{/PhysicalDriveSmartStats channel=.*([0-9]+).*id.*([0-9]+).*isDescriptionAvailable/} @smart);

$str="Device #";
$count_disks=scalar(grep{/$str/} @data);

@state=(grep{/^\s+State\s+:\s/} @data);
@speed=(grep{/^\s+Transfer Speed\s+:\s/} @data);
@channel=(grep{/^\s+Reported Channel.*:\s/} @data);
@model=(grep{/^\s+Model\s+:\s/} @data);
@serial=(grep{/^\s+Serial number\s+:\s/} @data);
@cache=(grep{/^\s+Write Cache\s+:\s/} @data);

@RSC=(grep{/0x05.*rawValue.*"([0-9]+)".*/} @smart);
@POH=(grep{/0x09.*rawValue.*"([0-9]+)".*/} @smart);
@CIT=(grep{/0xC2.*rawValue.*"([0-9]+)".*/} @smart);
@REC=(grep{/0xC4.*rawValue.*"([0-9]+)".*/} @smart);
@CPS=(grep{/0xC5.*rawValue.*"([0-9]+)".*/} @smart);
@USC=(grep{/0xC6.*rawValue.*"([0-9]+)".*/} @smart);


for($j = 1; $j <= $count_disks; $j++) {

@result[$j-1]=@result[$j-1] . "posi=" . ($j-1) . "|0|";

$str=@channel[$j-1];
$str=~/\(([0-9]+):([0-9]+)/;
@result[$j-1]=@result[$j-1] . "RC=" . $i . "/" . $2 . "/" . $1 .  "|1|";

$str=@serial[$j-1];
$str=~/:\s+(.*\S)/;
@result[$j-1]=@result[$j-1] . "SN=" . $1 .  "|2|";

$str=@state[$j-1];
$str=~/^\s+State\s+:\s(.*\S)/;
@result[$j-1]=@result[$j-1] . "SD=" . $1 .  "|3|";

$str=@speed[$j-1];
$str=~/\s+Transfer Speed\s+:\s(.*)\s([0-9])/;
@result[$j-1]=@result[$j-1] . "TD=" . $1 . "/" . $2 .  "|4|";

$str=@model[$j-1];
$str=~/\s+Model\s+:\s(.*\S)\s/;
$str=$1;

@result[$j-1]=@result[$j-1] . "MD=" . $1 . "|5|";

$str=@cache[$j-1];
$str=~/\s+Write Cache\s+:\s(.*\S)/;
@result[$j-1]=@result[$j-1] . "CD=" . $1  .  "|6|";

@result[$j-1]=@result[$j-1];

}



$str="PhysicalDriveSmartStats channel=.*([0-9]+).*id.*([0-9]+).*isDescriptionAvailable";
$count_sata_disks=scalar(grep{/$str/} @disks);


for($j = 1; $j <= $count_sata_disks; $j++) {
$str=@disks[$j-1];


$str=~/PhysicalDriveSmartStats channel=.*([0-9]+).*id.*([0-9]+).*isDescriptionAvailable/;
$ch=$1;
$id=$2;

$str1=(grep{/posi.*([0-9]+)\|0RC=$i\/$ch\/$id\|1\|/} @result)[0];


$str1=~/posi.*([0-9]+)\|0RC=$i\/$ch\/$id\|1/;

$pos=$1;

$str=@RSC[$j-1];
$str=~/0x05.*rawValue.*"([0-9]+)".*/;
@result[$pos]=@result[$pos] . "RSC=" . $1 .  "|7|";

$str=@POH[$j-1];
$str=~/0x09.*rawValue.*"([0-9]+)".*/;
@result[$pos]=@result[$pos] . "POH=" . $1 .  "|8|";

$str=@CIT[$j-1];
$str=~/0xC2.*rawValue.*"([0-9]+)".*/;
@result[$pos]=@result[$pos] . "CIT=" . $1 .  "|9|";

$str=@REC[$j-1];
$str=~/0xC4.*rawValue.*"([0-9]+)".*/;
@result[$pos]=@result[$pos] . "REC=" . $1  .  "|10|";

$str=@CPS[$j-1];
$str=~/0xC5.*rawValue.*"([0-9]+)".*/;
@result[$pos]=@result[$pos] . "CPS=" . $1  .  "|11|";

$str=@USC[$j-1];
$str=~/0xC6.*rawValue.*"([0-9]+)".*/;
@result[$pos]=@result[$pos] . "USC=" . $1  .  "|12|";


}

$str='<PhysicalDriveSmartStats channel=.*([0-9]+).*id.*([0-9]+)" >';


@disks=(grep{/$str/} @smart);

$count_sas_disks=scalar(grep{/$str/} @disks);

$str='<Attribute name="SMART Health Status" Value="(.*)"';
@SMT=(grep{/$str/} @smart);

$str='<Attribute name="Current Drive Temperature In Celcius" Value="([0-9]+)"';
@CTD=(grep{/$str/} @smart);

$str='<Attribute name="Total Uncorrected Read Errors" Value="([0-9]+)"';
@URE=(grep{/$str/} @smart);

$str='<Attribute name="Total Write Errors Corrected" Value="([0-9]+)"';
@UWE=(grep{/$str/} @smart);

$str='<Attribute name="Elements In Grown Defect List" Value="([0-9]+)"';
@EDL=(grep{/$str/} @smart);


for($j = 1; $j <= $count_sas_disks; $j++) {

$str=@disks[$j-1];


$str1='<PhysicalDriveSmartStats channel=.*([0-9]+).*id.*([0-9]+)" >';
$str=~/$str1/;
$ch=$1;
$id=$2;



$str1=(grep{/posi.*([0-9]+)\|0\|RC=$i\/$ch\/$id\|1\|/} @result)[0];

#print $str1;

$str1=~/posi.*([0-9]+)\|0\|RC=$i\/$ch\/$id\|1\|/;

$pos=$1;

#print $pos . " ch $ch id  $id " . "\n";

#exit;

$str=@SMT[$j-1];


$str1="(Passed)";


$str=~/$str1/;

if ($1 eq "Passed") {@result[$pos]=@result[$pos] . "SMT=1|7|";} else {@result[$pos]=@result[$pos] . "SMT=0|7|";}

$str1='<Attribute name="Current Drive Temperature In Celcius" Value="([0-9]+)"';
$str=@CTD[$j-1];
$str=~/$str1/;
@result[$pos]=@result[$pos] . "CTD=" . $1 .  "|8|";

$str1='<Attribute name="Total Uncorrected Read Errors" Value="([0-9]+)"';
$str=@URE[$j-1];
$str=~/$str1/;
@result[$pos]=@result[$pos] . "URE=" . $1 .  "|9|";

$str1='<Attribute name="Total Write Errors Corrected" Value="([0-9]+)"';
$str=@UWE[$j-1];
$str=~/$str1/;
@result[$pos]=@result[$pos] . "UWE=" . $1 .  "|10|";

$str1='<Attribute name="Elements In Grown Defect List" Value="([0-9]+)"';
$str=@EDL[$j-1];
$str=~/$str1/;
@result[$pos]=@result[$pos] . "EDL=" . $1 .  "|11|";
}
}

for($j = 1; $j <= $count_disks; $j++) {
@result[($j-1)]=@result[($j-1)] . "\n";
}
print @result;
}




sub discovery {
@data=` /usr/StorMan/arcconf list `;

$ctrl_count=@data[0];
$ctrl_count=~/([0-9]+)/;
$ctrl_count=$1;
$result="";
$first = 1;

print "{\n";
print "\t\"data\":[\n\n";
for($i = 1; $i <= $ctrl_count; $i++) {
$str=(grep{/Controller $1/} @data)[0];
#print $str;
#exit;

$str=~/.*,.*,.(.*),.(.*),/;

    print "\t,\n" if not $first;
    print "\t{\n";
    print "\t\t\"{#ADAPTER_MODEL}\":\"$1\",\n";
    print "\t\t\"{#ADAPTER_SERIAL}\":\"$2\"\n";
    print "\t}";
$list=$list." ".$serial;
$first = 0;

}
$result=$result . "\n\t]\n}";
print $result;
}


sub stormandata {
$str='cat /var/lib/dpkg/status |grep "Package: storman$" -A 7';
$data=`$str`;

$str=(grep{/Version:.(.*)/} $data);


if ($str==1) {
$data=~/Version:.(.*)/;
print $1 . "asdf\n";
}
}



sub discoverydiskssas {
@data=` /usr/StorMan/arcconf list `;
$ctrl_count=@data[0];
$ctrl_count=~/([0-9]+)/;
$ctrl_count=$1;
$result="";
$first = 1;
$list="";

print "{\n";
print "\t\"data\":[\n\n";

for($i = 1; $i <= $ctrl_count; $i++) {

#print "tst\n";

@data=` /usr/StorMan/arcconf getconfig $1 PD `;

$str="Device #";
$count_disks=scalar(grep{/$str/} @data);

#@state=(grep{/^\s+State\s+:\s/} @data);
@speed=(grep{/^\s+Transfer Speed\s+:\s/} @data);
#@channel=(grep{/^\s+Reported Channel.*:\s/} @data);
@model=(grep{/^\s+Model\s+:\s/} @data);
@serial=(grep{/^\s+Serial number\s+:\s/} @data);
#@cache=(grep{/^\s+Write Cache\s+:\s/} @data);

for($j = 1; $j <= $count_disks; $j++) {

$str=@speed[$j-1];
$str=~/\s+Transfer Speed\s+:\s(.*)\s([0-9])/;
if ($1 eq "SATA") {next;}

    print "\t,\n" if not $first;
    print "\t{\n";

$str1=@model[$j-1];
$str1=~/\s+Model\s+:\s(.*)/;
    print "\t\t\"{#Model}\":\"$1\",\n";

$str1=@serial[$j-1];
$str1=~/:\s+(.*)/;
    print "\t\t\"{#Serial}\":\"$1\"\n";

    print "\t}";
$list=$list." ".$serial;
$first = 0;
}
}
$result=$result . "\n\t]\n}\n";
print $result;
}

sub discoverydiskssata {
@data=` /usr/StorMan/arcconf list `;
$ctrl_count=@data[0];
$ctrl_count=~/([0-9]+)/;
$ctrl_count=$1;
$result="";
$first = 1;
$list="";

print "{\n";
print "\t\"data\":[\n\n";

for($i = 1; $i <= $ctrl_count; $i++) {

#print "tst\n";

@data=` /usr/StorMan/arcconf getconfig $1 PD `;

$str="Device #";
$count_disks=scalar(grep{/$str/} @data);

#@state=(grep{/^\s+State\s+:\s/} @data);
@speed=(grep{/^\s+Transfer Speed\s+:\s/} @data);
#@channel=(grep{/^\s+Reported Channel.*:\s/} @data);
@model=(grep{/^\s+Model\s+:\s/} @data);
@serial=(grep{/^\s+Serial number\s+:\s/} @data);
#@cache=(grep{/^\s+Write Cache\s+:\s/} @data);

for($j = 1; $j <= $count_disks; $j++) {

$str=@speed[$j-1];
$str=~/\s+Transfer Speed\s+:\s(.*)\s([0-9])/;
if ($1 eq "SAS") {next;}

    print "\t,\n" if not $first;
    print "\t{\n";

$str1=@model[$j-1];
$str1=~/\s+Model\s+:\s(.*)/;
    print "\t\t\"{#MODEL}\":\"$1\",\n";

$str1=@serial[$j-1];
$str1=~/:\s+(.*)/;
    print "\t\t\"{#SERIAL}\":\"$1\"\n";

    print "\t}";
$list=$list." ".$serial;
$first = 0;
}
}
$result=$result . "\n\t]\n}\n";
print $result;
}


sub controllersdata {

@data=` /usr/StorMan/arcconf list `;
#open my $file, '>', '/tmp/adaptecdata';
#print $file @data;
#close $file;

#$t=`echo @data > /222`;

$ctrl_count=@data[0];
$ctrl_count=~/([0-9]+)/;
$ctrl_count=$1;
@out='';
$result='';

for($i = 1; $i <= $ctrl_count; $i++) {
@data=` /usr/StorMan/arcconf getconfig $i ad`;

#$str=~//;

$str=(grep{/.*Controller Serial Number.*:\s+(.*)/} @data)[0];
$str=~/.*Controller Serial Number.*:\s+(.*)/;
$result=$result . "CSN=" . $1 . "|1|";

$str=(grep{/.*Controller Status.*:\s+(.*)/} @data)[0];
$str=~/.*Controller Status.*:\s+(.*)/;
$result=$result . "CS=" . $1 . "|2|";

$str=(grep{/.*Temperature.*:\s+([0-9]+)\s+C/} @data)[0];
$str=~/.*Temperature.*:\s+([0-9]+)\s+C/;
$result=$result . "CT=" . $1 . "|3|";


$str=(grep{/.*Controller Alarm.*:\s+(.*)/} @data)[0];
$str=~/.*Controller Alarm.*:\s+(.*)/;

if ($1 eq "Enabled") {$result=$result . "CA=1|4|";}
elsif ($1 eq "Disabled") {$result=$result . "CA=0|4|";} else {$result=$result . "CA=2|4|";}

$str=(grep{/.*Automatic Failover.*:\s+(.*)/} @data)[0];
$str=~/.*Automatic Failover.*:\s+(.*)/;

if ($1 eq "Enabled") {$result=$result . "AF=1|5|";}
elsif ($1 eq "Disabled") {$result=$result . "AF=0|5|";} else {$result=$result . "AF=2|5|";}

$tmp='.*Logical devices/Failed/Degraded.*\s+([0-9])/([0-9])/([0-9])';
$str=(grep{/$tmp/} @data)[0];
$str=~/$tmp/;
$result=$result . "LD=" . $1 . "/" . $2 . "/" . $3 . "|6|";
$j++;

$tmp='.*Firmware.*\((.*[0-9]+)';
$str=(grep{/$tmp/} @data)[0];
$str=~/$tmp/;
$result=$result . "CF=" . $1 . "|7|";
$j++;


$tmp='\s\s\sStatus.*:\s(.*)';
$str=(grep{/$tmp/} @data)[0];
$str=~/$tmp/;
$result=$result . "BS=" . $1 . "|8|";
$j++;


$result=$result . "\n";
}
print "$result";

}





$param=@ARGV[0];
if ( $param eq "discovery" )    	{discovery();exit 0;}
if ( $param eq "controllersdata" )      {controllersdata();exit 0;}
if ( $param eq "discoverydiskssas" )    {discoverydiskssas();exit 0;}
if ( $param eq "discoverydiskssata" )   {discoverydiskssata();exit 0;}
if ( $param eq "disksdata" )       	{disksdata();exit 0;}
if ( $param eq "diskssmartssata" )      {diskssmartssata();exit 0;}
if ( $param eq "stormandata" )      	{stormandata();exit 0;}
print "error?\n";
exit;
