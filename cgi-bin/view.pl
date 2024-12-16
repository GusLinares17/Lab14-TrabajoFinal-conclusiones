#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;

# Crear instancia CGI y obtener parámetros
my $q      = CGI->new;
my $owner  = $q->param('usuario');
my $titulo = $q->param('titulo');

# Conexión a la base de datos
my $db_user     = 'alumno';
my $db_password = 'pweb1';
my $db_dsn      = "DBI:MariaDB:database=pweb1;host=192.168.1.6";
my $dbh         = DBI->connect($db_dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 })
    or die("No se pudo conectar a la base de datos: $DBI::errstr");

# Consultar contenido en markdown
my $sth = $dbh->prepare("SELECT markdown FROM Articles WHERE owner = ? AND title = ?");
$sth->execute($owner, $titulo);

# Extraer resultados
my @markdown_content;
while (my @row = $sth->fetchrow_array) {
    push(@markdown_content, @row);
}

$sth->finish;
$dbh->disconnect;

# Procesar markdown
my @lineas = split("\n", $markdown_content[0] // '');
my $textoHTML = '';

foreach my $linea (@lineas) {
    my $lineaHTML = matchLine($linea);
    $textoHTML .= $lineaHTML;
}

# Generar respuesta en XML
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";
print "<root>\n";
print $textoHTML;
print "</root>\n";

# Subrutina para procesar cada línea de markdown
sub matchLine {
    my $linea = shift;

    # Si la línea no está vacía, procesarla
    if ($linea !~ /^\s*$/) {

        # Reemplazos para markdown -> HTML
        while ($linea =~ /(.*)(\*\*\*)(.*?)(\*\*\*)(.*)/) {
            $linea = "$1<strong><em>$3</em></strong>$5";
        }
        while ($linea =~ /(.*)(\*\*)(.*?)(\*\*)(.*)/) {
            $linea = "$1<strong>$3</strong>$5";
        }
        while ($linea =~ /(.*)(\*)(.*?)(\*)(.*)/) {
            $linea = "$1<em>$3</em>$5";
        }
        while ($linea =~ /(.*)(\_)(.*?)(\_)(.*)/) {
            $linea = "$1<em>$3</em>$5";
        }
        while ($linea =~ /(.*)(\[)(.*?)(\])(\()(.*?)(\))(.*)/) {
            $linea = "$1<a href='$6'>$3</a>$8";
        }
        while ($linea =~ /(.*)(\~\~)(.*?)(\~\~)(.*)/) {
            $linea = "$1<del>$3</del>$5";
        }

        # Reemplazo de encabezados
        if ($linea =~ /^\#{6}\s+(.*)/) {
            return "<h6>$1</h6>\n";
        } elsif ($linea =~ /^\#{5}\s+(.*)/) {
            return "<h5>$1</h5>\n";
        } elsif ($linea =~ /^\#{4}\s+(.*)/) {
            return "<h4>$1</h4>\n";
        } elsif ($linea =~ /^\#{3}\s+(.*)/) {
            return "<h3>$1</h3>\n";
        } elsif ($linea =~ /^\#{2}\s+(.*)/) {
            return "<h2>$1</h2>\n";
        } elsif ($linea =~ /^\#\s+(.*)/) {
            return "<h1>$1</h1>\n";
        } else {
            return "<p>$linea</p>\n";
        }
    }
    return "";
}
