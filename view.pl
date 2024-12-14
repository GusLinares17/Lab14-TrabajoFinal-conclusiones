#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Conexión a la base de datos
my $dbh = DBI->connect('DBI:mysql:database=tu_base;host=localhost', 'usuario', 'contraseña', { RaiseError => 1, AutoCommit => 1 });

my $owner = param('owner');
my $title = param('title');

print header(-type => 'text/html', -charset => 'UTF-8');

if ($owner && $title) {
    my $sth = $dbh->prepare("SELECT text FROM Articles WHERE owner = ? AND title = ?");
    $sth->execute($owner, $title);

    if (my $row = $sth->fetchrow_hashref) {
        my $html_content = convertir_markdown($row->{text});
        print $html_content;
    } else {
        print "<h1>Error: Artículo no encontrado.</h1>";
    }

    $sth->finish;
} else {
    print "<h1>Error: Parámetros faltantes.</h1>";
}

$dbh->disconnect;

# Función para convertir Markdown a HTML
sub convertir_markdown {
    my ($texto) = @_;

    # Reglas simples de Markdown
    $texto =~ s/######\s*(.+)$/<h6>$1<\/h6>/gm;
    $texto =~ s/#####\s*(.+)$/<h5>$1<\/h5>/gm;
    $texto =~ s/####\s*(.+)$/<h4>$1<\/h4>/gm;
    $texto =~ s/###\s*(.+)$/<h3>$1<\/h3>/gm;
    $texto =~ s/##\s*(.+)$/<h2>$1<\/h2>/gm;
    $texto =~ s/#\s*(.+)$/<h1>$1<\/h1>/gm;

    $texto =~ s/\*\*(.+?)\*\*/<strong>$1<\/strong>/g;
    $texto =~ s/\*(.+?)\*/<em>$1<\/em>/g;
    $texto =~
