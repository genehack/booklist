package App::Booklist::CLI::BASE;
use Moose;
use namespace::autoclean;
use 5.010;
extends 'MooseX::App::Cmd::Command';
with 'MooseX::SimpleConfig';

use App::Booklist::Schema;
use File::Basename;
use File::Path      qw/ make_path /;
use FindBin;

has file => (
  isa => 'Str' ,
  is  => 'rw' ,
  documentation => 'Location of DB file.' ,
  traits => [qw(Getopt)],
  default => "$FindBin::Bin/../db/booklist.db",
);

sub connect_to_db {
  my( $self , $db ) = @_;
  $db ||= $self->file;
  return App::Booklist::Schema->connect( "dbi:SQLite:$db" );
}

sub deploy_db {
  my( $self , $db ) = @_;
  $db ||= $self->file;

  my $path = dirname( $db );
  make_path( $path );

  my $add_drop_flag = ( -e $db ) ? 1 : 0;

  my $schema = $self->connect_to_db( $db );
  $schema->deploy({ add_drop_table => $add_drop_flag });

  return $schema;
}

sub get_schema {
  my( $self ) = shift;

  my $db = $self->file;

  unless ( -e $db ) {
    printf STDERR <<EOM and exit(1);
ERROR: Unable to connect to database.
Do you need to run 'make_database'?
EOM
  }

  return $self->connect_to_db();
}

sub get_schema_and_deploy_db_if_needed {
  my( $self ) = shift;

  my $db = $self->file;

  return $self->deploy_db()
    unless -e $db;

  return $self->get_schema;
}

1;
