#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

## Borramos elemento seleccionado

my $q = CGI->new;
my $owner = $q->param('usuario');
my $titulo = $q->param('titulo');

my $user = 'root';
my $password = 'wikipass';
my $dsn = "DBI:MariaDB:database=my_database;host=db";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

# Consultamos la página
my $sth = $dbh->prepare("SELECT * FROM Articles WHERE owner=? AND title=?");
$sth->execute($owner, $titulo);
my @row = $sth->fetchrow_array;

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if (!(@row == 0)) {
    # Si existe una página con el usuario y título...
    my $sth = $dbh->prepare("DELETE FROM Articles WHERE owner=? AND title=?");
    $sth->execute($owner, $titulo);
    $sth->finish;

    print "<article>";
    print "<owner>$owner</owner>";
    print "<title>$titulo</title>";
    print "</article>";
}
else {
    print "<article>";
    print "<owner></owner>";
    print "<title></title>";
    print "</article>";
}

$dbh->disconnect;