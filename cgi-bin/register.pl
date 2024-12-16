#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;

# Crear instancia CGI y obtener parámetros
my $q = CGI->new;
my $nombres       = $q->param('Nombre');
my $apellidos     = $q->param('Apellido');
my $nombreUsuario = $q->param('usuario');
my $contra        = $q->param('password');

# Conexión a la base de datos
my $db_user     = 'alumno';
my $db_password = 'pweb1';
my $db_dsn      = "DBI:MariaDB:database=pweb1;host=192.168.1.6";
my $dbh         = DBI->connect($db_dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 })
    or die("No se pudo conectar a la base de datos: $DBI::errstr");

# Verificar si el usuario ya existe
my $sth_check = $dbh->prepare("SELECT * FROM Users WHERE userName = ?");
$sth_check->execute($nombreUsuario);
my @user_row = $sth_check->fetchrow_array;
$sth_check->finish;

# Respuesta en XML
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if (!@user_row) {
    # Si el usuario no existe, agregarlo a la base de datos
    my $sth_insert = $dbh->prepare(
        "INSERT INTO Users (userName, password, lastName, firstName) VALUES (?, ?, ?, ?)"
    );
    $sth_insert->execute($nombreUsuario, $contra, $apellidos, $nombres);
    $sth_insert->finish;

    # Generar respuesta XML para usuario agregado
    print "<user>\n";
    print "  <owner>$nombreUsuario</owner>\n";
    print "  <firstName>$nombres</firstName>\n";
    print "  <lastName>$apellidos</lastName>\n";
    print "</user>\n";
} else {
    # Generar respuesta XML para usuario ya existente
    print "<user>\n";
    print "  <owner></owner>\n";
    print "  <firstName></firstName>\n";
    print "  <lastName></lastName>\n";
    print "</user>\n";
}

# Desconectar de la base de datos
$dbh->disconnect;
