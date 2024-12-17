#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

# Recibimos parámetros
my $q = CGI->new;
my $owner = $q->param("usuario");

my $user = 'root';
my $password = 'wikipass';
my $dsn = "DBI:MariaDB:database=my_database;host=db";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Listado de páginas
my $sth = $dbh->prepare("SELECT title FROM Articles WHERE owner=?");
$sth->execute($owner);

print "<articles>\n";
while (my @row = $sth->fetchrow_array) {
    print "<article>\n";
    print "<owner>$owner</owner>\n";
    print "<title>@row</title>\n";
    print "</article>\n";
}
print "</articles>\n";

$sth->finish;
$dbh->disconnect;