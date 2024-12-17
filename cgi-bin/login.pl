#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

my $q = CGI->new;
my $nombreUsuario = $q->param('usuario');
my $contra = $q->param('password');

# Conectamos con la base de datos
my $user = 'root';
my $password = 'wikipass';
my $dsn = "DBI:MariaDB:database=my_database;host=db";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
my $sth = $dbh->prepare("SELECT * FROM Users WHERE userName=? AND password=?");
$sth->execute($nombreUsuario, $contra);
my @row = $sth->fetchrow_array;
$sth->finish;

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if (!(@row == 0)) {
    # Si existe el usuario en la base de datos...
    my $sth = $dbh->prepare("SELECT firstName FROM Users WHERE userName=?");
    $sth->execute($nombreUsuario);
    my @row2 = $sth->fetchrow_array;
    $sth->finish;

    $sth = $dbh->prepare("SELECT lastName FROM Users WHERE userName=?");
    $sth->execute($nombreUsuario);
    my @row3 = $sth->fetchrow_array;
    $sth->finish;

    print "<user>\n";
    print "<owner>$nombreUsuario</owner>\n";
    print "<firstName>$row2[0]</firstName>\n";
    print "<lastName>$row3[0]</lastName>\n";
    print "</user>\n";
}
else {
    print "<user>\n";
    print "</user>\n";
}

$dbh->disconnect;