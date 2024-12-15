#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Conexión a la base de datos
my $dbh = DBI->connect('DBI:mysql:database=tu_base;host=localhost', 'usuario', 'contraseña', { RaiseError => 1, AutoCommit => 1 });

my $owner = param('owner');
my $title = param('title');

print header(-type => 'application/xml', -charset => 'UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if ($owner && $title) {
    my $sth = $dbh->prepare("SELECT text FROM Articles WHERE owner = ? AND title = ?");
    $sth->execute($owner, $title);

    if (my $row = $sth->fetchrow_hashref) {
        print "<article>\n";
        print "  <owner>$owner</owner>\n";
        print "  <title>$title</title>\n";
        print "  <text>$row->{text}</text>\n";
        print "</article>\n";
    } else {
        print "<article></article>\n";
    }

    $sth->finish;
} else {
    print "<article></article>\n";
}

$dbh->disconnect;
