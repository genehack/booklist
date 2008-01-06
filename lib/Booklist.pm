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


my $db;
sub db_handle {
  my( $class ) = ( @_ );
  
  return $db if $db;

  my $DB_FILE = $class->db_location;

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

  if( -e $DB_FILE ) {
    return $DB_FILE;
  }
  else {
    die "Database file '$DB_FILE' doesn't exist -- maybe run 'make_database' command?";
  }
}

sub epoch2ymd {
  my( $class , $date ) = @_;

  my $t;
  eval {
    $t = DateTime->from_epoch( epoch => $date );
  };
  die $@ if $@;
  
  return sprintf "%4d%02d%02d" , $t->year , $t->month , $t->day;
}

sub ymd2epoch {
  my( $class , $date )  = @_;
  
  die "Date must be in YYYYMMDD format"
    unless $date =~ /^\d{8}$/;
    
  my( $yr , $mo , $dy ) = $date =~ /^(\d{4})(\d{2})(\d{2})$/;

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

Booklist - Convenience functions for the 'booklist' application. 

=head1 SYNOPSIS

You don't use this directly. 

=head1 INTERFACE

=head2 db_handle

    my $db = Booklist->db_handle();

Returns a DBIx::Class::Schema object connected to the booklist database

=head2 db_location 

    my $dbfile = Booklist->db_location();

Returns the filesystem path to the file containing the Booklist SQLite
database.

=head2 epoch2ymd

    my $ymd = Booklist->epoch2ymd( $epoch_time_value );

Converts epoch time into a 'YYYYMMDD' string

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
