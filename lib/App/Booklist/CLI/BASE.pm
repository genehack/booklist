package App::Booklist::CLI::BASE;
use Moose;
use namespace::autoclean;
use 5.010;
extends 'MooseX::App::Cmd::Command';
with 'MooseX::SimpleConfig';

use App::Booklist::Schema;
use Business::ISBN;
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

sub validate_isbn {
  my( $self , $isbn ) = @_;

  $isbn = Business::ISBN->new( $isbn )
    and $isbn->is_valid
    or $self->usage_error( "That is not a valid ISBN" );

  return $isbn->as_string;
}

1;

__END__

=head1 NAME

App::Booklist::CLI::BASE - base class for commands

=head1 AUTHOR

John SJ Anderson, C<< <genehack at genehack.org> >>

=head1 METHODS

=head2 connect_to_db

Connect to an App::Booklist::Schema and return the schema object. Will use the
DB file from the 'file' attribute, or can be passed an optional argument
that's a path to a different DB, in which case it will use that instead.

=head2 deploy_db

Uses the 'connect_to_db' method to get a schema object, and then uses that to
deploy a fresh schema to the database. Will set the 'add_drop_table' flag
depending on whether that DB file existed prior to the schema object
connection.

=head2 get_schema

Checks for the existance of a DB file and either throws an exception (if not
found) or returns a schema object (if found).

=head2 get_schema_and_deploy_db_if_needed

Like 'get_schema', but will deploy the database if the database file is not
found.

=head2 validate_isbn

Wrapper around Business::ISBN that confirms that a given string is a valid
ISBN. Throws a usage_error() if the ISBN is invalid, or returns the result of
the Business::ISBN::as_string() method if it is valid.

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-booklist at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Booklist>.  I will be
notified, and then you'll automatically be notified of progress on your bug as
I make changes.

=head1 LICENSE AND COPYRIGHT

Copyright 2010 John SJ Anderson.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
