#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

# Recibimos parámetros
my $q = CGI->new;
my $owner = $q->param("usuario");
my $titulo = $q->param("titulo");
my $markdown = $q->param("cuerpo");

# Conectamos a la base de datos
my $user = 'root';
my $password = 'wikipass';
my $dsn = "DBI:MariaDB:database=my_database;host=db";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("SELECT * FROM Users WHERE userName=?");
$sth->execute($owner);
my @row = $sth->fetchrow_array;

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if (!(@row == 0)) {
    # Si existe un usuario con el nombre dado...
    my @titulos;
    my $sth = $dbh->prepare("SELECT title FROM Articles WHERE owner=?");
    $sth->execute($owner);

    while (my @row2 = $sth->fetchrow_array) {
        push(@titulos, @row2);
    }

    if (@titulos && $titulos[0] eq $titulo) {
        my $sth1 = $dbh->prepare("UPDATE Articles SET markdown=? WHERE title=? AND owner=?");
        $sth1->execute($markdown, $titulo, $owner);
        $sth1->finish;
    }
    else {
        my $sth2 = $dbh->prepare("INSERT INTO Articles (title, owner, markdown) VALUES (?, ?, ?)");
        $sth2->execute($titulo, $owner, $markdown);
        $sth2->finish;
    }
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