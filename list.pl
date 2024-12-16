#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Conexión a la base de datos
my $dbh = DBI->connect('DBI:mysql:database=tu_base;host=localhost', 'usuario', 'contraseña', { RaiseError => 1, AutoCommit => 1 });

my $owner = param('owner');

print header(-type => 'application/xml', -charset => 'UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if ($owner) {
    my $sth = $dbh->prepare("SELECT title FROM Articles WHERE owner = ?");
    $sth->execute($owner);

    print "<articles>\n";
    while (my $row = $sth->fetchrow_hashref) {
        print "  <article>\n";
        print "    <owner>$owner</owner>\n";
        print "    <title>$row->{title}</title>\n";
        print "  </article>\n";
    }
    print "</articles>\n";

    $sth->finish;
} else {
    print "<articles></articles>\n";
}

$dbh->disconnect;
