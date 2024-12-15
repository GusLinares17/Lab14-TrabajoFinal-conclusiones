#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Conexión a la base de datos
my $dbh = DBI->connect('DBI:mysql:database=tu_base;host=localhost', 'usuario', 'contraseña', { RaiseError => 1, AutoCommit => 1 });

my $user = param('user');
my $password = param('password');

print header(-type => 'application/xml', -charset => 'UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if ($user && $password) {
    my $sth = $dbh->prepare("SELECT userName, firstName, lastName FROM Users WHERE userName = ? AND password = ?");
    $sth->execute($user, $password);

    if (my $row = $sth->fetchrow_hashref) {
        print "<user>\n";
        print "  <owner>$row->{userName}</owner>\n";
        print "  <firstName>$row->{firstName}</firstName>\n";
        print "  <lastName>$row->{lastName}</lastName>\n";
        print "</user>\n";
    } else {
        print "<user></user>\n";
    }
    $sth->finish;
} else {
    print "<user></user>\n";
}

$dbh->disconnect;
