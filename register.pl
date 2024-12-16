#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Conexión a la base de datos
my $dbh = DBI->connect('DBI:mysql:database=tu_base;host=localhost', 'usuario', 'contraseña', { RaiseError => 1, AutoCommit => 1 });

# Obtener parámetros del formulario
my $userName = param('userName');
my $password = param('password');
my $firstName = param('firstName');
my $lastName = param('lastName');

# Enviar encabezado XML
print header(-type => 'application/xml', -charset => 'UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Validación de parámetros
if (defined $userName && defined $password && defined $firstName && defined $lastName &&
    $userName =~ /^[a-zA-Z0-9_]+$/ && length($password) >= 6 && 
    $firstName =~ /^[a-zA-Z]+$/ && $lastName =~ /^[a-zA-Z]+$/) {

    # Preparar la consulta
    my $sth = $dbh->prepare("INSERT INTO Users (userName, password, firstName, lastName) VALUES (?, ?, ?, ?)");

    # Ejecutar la consulta con manejo de errores
    eval {
        $sth->execute($userName, $password, $firstName, $lastName);
        print "<user>\n";
        print "  <owner>$userName</owner>\n";
        print "  <firstName>$firstName</firstName>\n";
        print "  <lastName>$lastName</lastName>\n";
        print "</user>\n";
    };
    if ($@) { # Si ocurrió un error en la base de datos
        print "<error>Database error: $@</error>\n";
    }

    $sth->finish;
} else {
    # Respuesta si los parámetros no son válidos
    print "<error>Invalid input data</error>\n";
}

# Cerrar conexión a la base de datos
$dbh->disconnect;
