#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;

# Crear instancia CGI y obtener parámetros
my $q        = CGI->new;
my $owner    = $q->param('usuario');
my $titulo   = $q->param('titulo');
my $markdown = $q->param('cuerpo');

# Conexión a la base de datos
my $db_user     = 'alumno';
my $db_password = 'pweb1';
my $db_dsn      = "DBI:MariaDB:database=pweb1;host=192.168.1.6";
my $dbh         = DBI->connect($db_dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 })
    or die("No se pudo conectar a la base de datos: $DBI::errstr");

# Consultar si el artículo ya existe
my $sth_check = $dbh->prepare("SELECT markdown FROM Articles WHERE owner = ? AND title = ?");
$sth_check->execute($owner, $titulo);
my @row = $sth_check->fetchrow_array;
$sth_check->finish;

# Respuesta en XML
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if (@row) {
    # Si el artículo existe, actualizar el contenido
    my $sth_update = $dbh->prepare("UPDATE Articles SET markdown = ? WHERE title = ? AND owner = ?");
    $sth_update->execute($markdown, $titulo, $owner);
    $sth_update->finish;

    # Generar respuesta XML
    print "<article>\n";
    print "  <title>$titulo</title>\n";
    print "  <text>$markdown</text>\n";
    print "</article>\n";
} else {
    # Si el artículo no existe, devolver un XML vacío
    print "<article>\n";
    print "  <title></title>\n";
    print "  <text></text>\n";
    print "</article>\n";
}

# Desconectar de la base de datos
$dbh->disconnect;
