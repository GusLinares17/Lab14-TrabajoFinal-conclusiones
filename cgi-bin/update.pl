#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

## Calculamos value de cuerpo

my $q = CGI->new;
my $owner = $q->param('usuario');
my $titulo = $q->param('titulo');
my $markdown = $q->param('cuerpo');

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
    # Si existe una página con el nombre y título dado...
    $sth = $dbh->prepare("UPDATE Articles SET markdown=? WHERE title=? AND owner=?");
    $sth->execute($markdown, $titulo, $owner);
    $sth->finish;

    print "<article>";
    print "<title>$titulo</title>";
    print "<text>$markdown</text>";
    print "</article>";
}
else {
    print "<article>";
    print "<title></title>";
    print "<text></text>";
    print "</article>";
}

$dbh->disconnect;