#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;

# Crear objeto CGI para manejar parámetros
my $q = CGI->new;
my $owner = $q->param('usuario');
my $titulo = $q->param('titulo');

# Configuración de conexión a la base de datos
my $db_user = 'alumno';
my $db_password = 'pweb1';
my $db_dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.6";

# Conectar a la base de datos
my $dbh = DBI->connect($db_dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 })
    or die("No se pudo conectar a la base de datos: $DBI::errstr");

# Consultar si existe la página con el usuario y título dados
my $sth = $dbh->prepare("SELECT * FROM Articles WHERE owner = ? AND title = ?");
$sth->execute($owner, $titulo);
my @row = $sth->fetchrow_array;

# Generar respuesta XML
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

print "<article>";

if (@row) {
    # Si existe la página, proceder a borrarla
    my $delete_sth = $dbh->prepare("DELETE FROM Articles WHERE owner = ? AND title = ?");
    $delete_sth->execute($owner, $titulo);
    $delete_sth->finish;

    print "<owner>$owner</owner>";
    print "<title>$titulo</title>";
} else {
    # Si no existe la página, devolver datos vacíos
    print "<owner></owner>";
    print "<title></title>";
}

print "</article>";

# Limpiar recursos y cerrar conexión
$sth->finish;
$dbh->disconnect;