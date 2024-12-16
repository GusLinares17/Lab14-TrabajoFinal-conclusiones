#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;

# Recibir parámetros
my $q = CGI->new;
my $owner    = $q->param("usuario");
my $titulo   = $q->param("titulo");
my $markdown = $q->param("cuerpo");

# Conexión a la base de datos
my $db_user     = 'alumno';
my $db_password = 'pweb1';
my $db_dsn      = "DBI:MariaDB:database=pweb1;host=192.168.1.6";
my $dbh         = DBI->connect($db_dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 })
    or die("No se pudo conectar a la base de datos: $DBI::errstr");

# Verificar si el usuario existe
my $sth_user = $dbh->prepare("SELECT * FROM Users WHERE userName = ?");
$sth_user->execute($owner);
my @user_row = $sth_user->fetchrow_array;
$sth_user->finish;

# Respuesta XML
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if (@user_row) {
    # Si el usuario existe, verificar títulos existentes
    my $sth_titles = $dbh->prepare("SELECT title FROM Articles WHERE owner = ?");
    $sth_titles->execute($owner);

    my $title_exists = 0;
    while (my @row = $sth_titles->fetchrow_array) {
        if ($row[0] eq $titulo) {
            $title_exists = 1;
            last;
        }
    }
    $sth_titles->finish;

    if ($title_exists) {
        # Si el título existe, actualizar el contenido
        my $sth_update = $dbh->prepare("UPDATE Articles SET markdown = ? WHERE title = ? AND owner = ?");
        $sth_update->execute($markdown, $titulo, $owner);
        $sth_update->finish;
    } else {
        # Si el título no existe, insertar nuevo artículo
        my $sth_insert = $dbh->prepare("INSERT INTO Articles (title, owner, markdown) VALUES (?, ?, ?)");
        $sth_insert->execute($titulo, $owner, $markdown);
        $sth_insert->finish;
    }

    print "<article>\n";
    print "  <title>$titulo</title>\n";
    print "  <text>$markdown</text>\n";
    print "</article>\n";
} else {
    # Si el usuario no existe
    print "<article>\n";
    print "  <title></title>\n";
    print "  <text></text>\n";
    print "</article>\n";
}

# Desconectar de la base de datos
$dbh->disconnect;
