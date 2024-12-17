#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

# Recibimos parámetros
my $q = CGI->new;
my $owner = $q->param("usuario");
my $titulo = $q->param("titulo");

# Conectamos a la base de datos
my $user = 'root';
my $password = 'wikipass';
my $dsn = "DBI:MariaDB:database=my_database;host=db";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("SELECT markdown FROM Articles WHERE owner=? AND title=?");
$sth->execute($owner, $titulo);
my @row = $sth->fetchrow_array;

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if (!(@row == 0)) {
    # Si existe una página con el usuario y título dado...
    $sth->finish;

    print "<article>";
    print "<owner>$owner</owner>";
    print "<title>$titulo</title>";
    print "<text>@row</text>";
    print "</article>";
}
else {
    print "<article>";
    print "<owner></owner>";
    print "<title></title>";
    print "<text></text>";
    print "</article>";
}

$dbh->disconnect;