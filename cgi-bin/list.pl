#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;

# Crear objeto CGI para manejar parámetros
my $q = CGI->new;
my $owner = $q->param("usuario");

# Configuración de conexión a la base de datos
my $db_user = 'alumno';
my $db_password = 'pweb1';
my $db_dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.6";

# Conectar a la base de datos
my $dbh = DBI->connect($db_dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 })
    or die("No se pudo conectar a la base de datos: $DBI::errstr");

# Preparar y ejecutar la consulta para obtener los títulos de las páginas del propietario
my $sth = $dbh->prepare("SELECT title FROM Articles WHERE owner = ?");
$sth->execute($owner);

# Generar respuesta XML
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";
print "<articles>\n";

# Recorrer y mostrar los resultados
while (my @row = $sth->fetchrow_array) {
    print "<article>\n";
    print "<owner>$owner</owner>";
    print "<title>$row[0]</title>";  # Acceder al primer elemento de la fila
    print "</article>\n";
}

print "</articles>\n";

# Limpiar recursos y cerrar la conexión
$sth->finish;
$dbh->disconnect;