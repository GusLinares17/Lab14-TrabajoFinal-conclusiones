#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;

# Crear objeto CGI para manejar parámetros
my $q = CGI->new;
my $nombreUsuario = $q->param('usuario');
my $contra = $q->param('password');

# Configuración de conexión a la base de datos
my $db_user = 'alumno';
my $db_password = 'pweb1';
my $db_dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.6";

# Conectar a la base de datos
my $dbh = DBI->connect($db_dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 })
    or die("No se puede conectar a la base de datos: $DBI::errstr");

# Consultar si existe el usuario con la contraseña proporcionada
my $sth = $dbh->prepare("SELECT userName FROM Users WHERE userName = ? AND password = ?");
$sth->execute($nombreUsuario, $contra);
my @row = $sth->fetchrow_array;
$sth->finish;

# Generar respuesta XML
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";
print "<user>\n";

if (@row) {
    # Si el usuario existe, obtener nombre y apellido
    my $sth_first_name = $dbh->prepare("SELECT firstName FROM Users WHERE userName = ?");
    $sth_first_name->execute($nombreUsuario);
    my ($first_name) = $sth_first_name->fetchrow_array;
    $sth_first_name->finish;

    my $sth_last_name = $dbh->prepare("SELECT lastName FROM Users WHERE userName = ?");
    $sth_last_name->execute($nombreUsuario);
    my ($last_name) = $sth_last_name->fetchrow_array;
    $sth_last_name->finish;

    print "<owner>$nombreUsuario</owner>\n";
    print "<firstName>$first_name</firstName>\n";
    print "<lastName>$last_name</lastName>\n";
}

print "</user>\n";

# Limpiar recursos y cerrar la conexión
$dbh->disconnect;