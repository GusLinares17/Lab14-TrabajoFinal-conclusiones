#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Conexión a la base de datos
my $dbh = DBI->connect('DBI:mysql:database=tu_base;host=localhost', 'usuario', 'contraseña', { RaiseError => 1, AutoCommit => 1 });

my $userName = param('userName');
my $password = param('password');
my $firstName = param('firstName');
my $lastName = param('lastName');

print header(-type => 'application/xml', -charset => 'UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if ($userName && $password && $firstName && $lastName) {
    my $sth = $dbh->prepare("INSERT INTO Users (userName, password, firstName, lastName) VALUES (?, ?, ?, ?)");
    eval {
        $sth->execute($userName, $password, $firstName, $lastName);
        print "<user>\n";
        print "  <owner>$userName</owner>\n";
        print "  <firstName>$firstName</firstName>\n";
        print "  <lastName>$lastName</lastName>\n";
        print "</user>\n";
    } or do {
        print "<user></user>\n";
    };
    $sth->finish;
} else {
    print "<user></user>\n";
}

$dbh->disconnect;
