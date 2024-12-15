#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Conexión a la base de datos
my $dbh = DBI->connect('DBI:mysql:database=tu_base;host=localhost', 'usuario', 'contraseña', { RaiseError => 1, AutoCommit => 1 });

my $title = param('title');
my $text = param('text');
my $owner = param('owner');

print header(-type => 'application/xml', -charset => 'UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if ($title && $text && $owner) {
    my $sth = $dbh->prepare("INSERT INTO Articles (title, text, owner) VALUES (?, ?, ?)");
    eval {
        $sth->execute($title, $text, $owner);
        print "<article>\n";
        print "  <title>$title</title>\n";
        print "  <text>$text</text>\n";
        print "</article>\n";
    } or do {
        print "<article></article>\n";
    };
    $sth->finish;
} else {
    print "<article></article>\n";
}

$dbh->disconnect;
