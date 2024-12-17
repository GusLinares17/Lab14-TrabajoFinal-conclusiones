#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

# Crear el objeto CGI para recibir parámetros
my $q = CGI->new;
my $owner = $q->param('usuario');
my $titulo = $q->param('titulo');

# Conexión a la base de datos
my $user = 'root';
my $password = 'wikipass';
my $dsn = "DBI:MariaDB:database=my_database;host=db";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

# Consultar el contenido en Markdown de la base de datos
my $sth = $dbh->prepare("SELECT markdown FROM Articles WHERE owner = ? AND title = ?");
$sth->execute($owner, $titulo);

my @texto = $sth->fetchrow_array;
$sth->finish;

# Validar si se encontró el artículo
if (!@texto) {
    print $q->header('text/XML');
    print "<?xml version='1.0' encoding='utf-8'?>\n";
    print "<root><error>No se encontró la página</error></root>\n";
    $dbh->disconnect;
    exit;
}

# Dividir el contenido Markdown en líneas
my @lineas = split "\n", $texto[0];
my $textoHTML = "";

# Convertir cada línea de Markdown a HTML
foreach my $linea (@lineas) {
    $textoHTML .= matchLine($linea);
}

# Generar la salida en XML
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";
print "<root>\n";
print "$textoHTML";
print "</root>\n";

# Cerrar la conexión a la base de datos
$dbh->disconnect;

# Función para convertir líneas Markdown a HTML
sub matchLine {
    my ($linea) = @_;

    # Ignorar líneas vacías
    return "" if $linea =~ /^\s*$/;

    # Negritas y cursivas
    $linea =~ s/\*\*\*(.*?)\*\*\*/<strong><em>$1<\/em><\/strong>/g;
    $linea =~ s/\*\*(.*?)\*\*/<strong>$1<\/strong>/g;
    $linea =~ s/\*(.*?)\*/<em>$1<\/em>/g;

    # Subrayado y tachado
    $linea =~ s/\_\_(.*?)\_\_/<strong>$1<\/strong>/g;
    $linea =~ s/\_(.*?)\_/<em>$1<\/em>/g;
    $linea =~ s/\~\~(.*?)\~\~/<del>$1<\/del>/g;

    # Links
    $linea =~ s/\[(.*?)\]\((.*?)\)/<a href="$2">$1<\/a>/g;

    # Encabezados
    if ($linea =~ /^(#{1,6})\s*(.+)$/) {
        my $level = length($1);
        return "<h$level>$2<\/h$level>\n";
    }

    # Texto normal
    return "<p>$linea<\/p>\n";
}