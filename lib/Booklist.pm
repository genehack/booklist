package Booklist;

# $Id$
# $URL$

use warnings;
use strict;

use version; our $VERSION = qv('0.0.1');

use DateTime;
use FindBin;
use YAML             qw/ LoadFile /;

use lib "$FindBin::Bin/../lib";
use Booklist::DB;

my $rc_file = "$ENV{HOME}/.booklistrc";


sub add_book {
  my( $class , $opt ) = ( @_ );

  my $db = $class->db_handle();
  
  my @authors;
  foreach my $author ( @{ $opt->{author} } ) {
    foreach my $a ( split /\s*,\s*/ , $author ) {
      push @authors ,
        $db->resultset('Author')->find_or_create({ author => $a });
    }
  }

  my @tags;
  foreach my $tag ( @{ $opt->{tag} } ) {
    foreach my $t ( split /\s*,\s*/ , $tag ) {
      push @tags , $db->resultset('Tag')->find_or_create({ tag => $t });
    }
  }
  
  my $book = $db->resultset('Book')->find_or_create({
    title  => $opt->{title} ,
    pages  => $opt->{pages} ,
  });


  $book->added( time() );
  $book->update();
  
    
  foreach my $author ( @authors ) {
    $db->resultset('AuthorBook')->find_or_create({
      author => $author->id ,
      book   => $book->id   ,
    });
  }

  foreach my $tag ( @tags ) {
    $db->resultset('BookTag')->find_or_create({
      book => $book->id ,
      tag  => $tag->id  ,
    });
  }

  return $book;
}

my $db;
sub db_handle {
  my( $class ) = ( @_ );
  
  return $db if $db;

  my $DB_FILE = $class->db_location;
  die "Database file '$DB_FILE' doesn't exist -- maybe run 'make_database' command?"
    unless -e $DB_FILE;
  
  $db = Booklist::DB->connect(
    "dbi:SQLite:$DB_FILE",
    q{}, q{}, { AutoCommit => 1 } ,
  );

  return $db;
}

my $DB_FILE;
sub db_location {
  my( $class ) = ( @_ );
  
  return $DB_FILE if $DB_FILE;

  if ( $ENV{BOOKLIST_DB} ) {
    $DB_FILE = $ENV{BOOKLIST_DB};
  }
  elsif ( -e $rc_file ) {
    my $config = LoadFile( $rc_file );
    $DB_FILE = $config->{db_file} || '';
  }
  else {
    $DB_FILE = "$ENV{HOME}/.booklist.db";
  }

}

sub epoch2ymd {
  my( $class , $date ) = @_;

  $date = time() unless defined $date;
  
  my $t;
  eval {
    $t = DateTime->from_epoch( epoch => $date )->ymd;
  };
  die $@ if $@;
  
  return $t;
}

sub ymd2epoch {
  my( $class , $date )  = @_;


  die "Date must be in YYYYMMDD format"
    unless $date =~ /^(\d{8}|\d{4}-\d{2}-\d{2})$/;
  
  my ( $yr , $mo , $dy ) = $date =~ /^(\d{4})-?(\d{2})-?(\d{2})$/;

  my $t;
  eval {
    $t = DateTime->new(
      year  => $yr , 
      month => $mo ,
      day   => $dy ,
    );
  };
  die $@ if $@;
  
  return $t->epoch;
}  







1; # Magic true value required at end of module



__END__

=head1 NAME

Booklist - Track books you want to read, are reading, and have read

=head1 SYNOPSIS

You don't use this directly. 

=head1 INTERFACE

=head2 add_book

    my $book = Booklist->add_book( $opt );

Returns a Booklist::DB::Book object corresponding to the newly created book.

Needs to be passed the second ($opt) arg passed to App::Cmd 'run()' functions, where ever that comes from. 


=head2 db_handle

    my $db = Booklist->db_handle();

Returns a DBIx::Class::Schema object connected to the booklist database

=head2 db_location 

    my $dbfile = Booklist->db_location();

Returns the filesystem path to the file containing the Booklist SQLite
database.

=head2 epoch2ymd

    my $ymd = Booklist->epoch2ymd( $epoch_time_value );
    my $current_ymd = Booklist->epoch2ymd();

Converts epoch time into a 'YYYYMMDD' string. Uses current time if one isn't given.

=head2 ymd2epoch

    my $epoch_time_value = Booklist->ymd2epoch( $ymd );

Converts a 'YYYYMMDD' string into epoch time.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

John SJ Anderson  C<< <genehack@genehack.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, John SJ Anderson C<< <genehack@genehack.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
