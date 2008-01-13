package Booklist::Cmd::Command::stats;

# $Id$
# $URL$

use warnings;
use strict;

use base qw/ App::Cmd::Command /;

use DateTime;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Booklist;

sub usage_desc { "%c stats" }

sub opt_spec {
  (
    [ 'year|y=s' , 'limit to a particular year' ] ,
    [ 'all|a'    , 'show all-time stats (default is year to-date)' ] ,
  )
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;

  # can't have both 'all' and a 'year'
  $self->usage_error("--year and --all are mutually exclusive")
    if $opt->{year} and $opt->{all};

  if ( $opt->{year} ) {
    $self->usage_error("--year takes a four-digit number as an arg")
      unless $opt->{year} =~ /^\d{4}$/;
  }
}


sub run {
  my( $self , $opt , $args ) = @_;

  my $db = Booklist->db_handle();

  my $search;
    
  if ( $opt->{all} ) {
    $search = undef;
  }
  elsif ( $opt->{year} ) {
    my $dt1 = DateTime->new( year => $opt->{year} );
    my $dt2 = DateTime->new( year => $opt->{year} + 1 );
    my $e1  = $dt1->epoch - 1;
    my $e2  = $dt2->epoch;
    $search = {
      startdate => { '>' => $e1 , '<' => $e2 } ,
    };
  }
  else {
    my $dt1  = DateTime->now;
    my $year = $dt1->year;
    my $dt2  = DateTime->new( year => $year );
    my $e1   = $dt2->epoch - 1;
    $search = {
      startdate => { '>' => $e1 } ,
    };
  }

  my @readings = $db->resultset('Reading')->search( $search ,
                                                    { order_by => 'id' } );

  my( %books , %authors , $total_duration );
  my $unfinished = 0;
  
  foreach my $r( @readings ) {
    my $book     = $r->book;
    my @authors  = $r->book->authors;
    my @tags     = $r->book->tags;
    my $duration = $r->duration;

    $books{$book->id}{count}++;
    $books{$book->id}{obj} = $book;
    
    foreach ( @authors ) {
      $authors{$_->id}{count}++;
      $authors{$_->id}{obj} = $_;
    }

    if ( $duration ) {
      $total_duration += $duration;
    }
    else {
      $unfinished++;
    }
  }
  
  my $book_count   = scalar keys %books;
  my $author_count = scalar keys %authors;
  my $finished = $book_count - $unfinished;

  my $max_read_count = 1;
  my @max_read;
  foreach ( keys %books  ) {
    if ( $books{$_}{count} > $max_read_count ) {
      $max_read_count = $books{$_}{count};
      push @max_read , $_;
    }
  }

  my $max_auth_count = 1;
  my $max_auth;
  foreach ( keys %authors ) {
    if ( $authors{$_}{count} > $max_auth_count ) {
      $max_auth_count = $authors{$_}{count};
      $max_auth = $authors{$_}{obj};
    }
  }
  printf "SAW %d BOOKS BY %d AUTHORS\n" , $book_count , $author_count;
  printf "FINISHED %d BOOK" , $finished;
  print 'S' unless $finished == 1;
  print "\n";
  if ( $total_duration ) {
    printf "TOTAL READING TIME: %d days\n" , $total_duration / (60 * 60 * 24);
    printf "AVERAGE READING TIME: %5.2f days\n" ,
      ( $total_duration / $finished ) / (60 * 60 * 24);
  }
  
  print "\n";

  if ( $max_read_count > 1 ) {
    printf "Most reads of a single book: %d\n" , $max_read_count;
    print  "You read these books more than once:\n";
    foreach ( @max_read ) {
      my $book = $books{$_}{obj};
      printf "\t%s (Reads: %d)\n" , $book->title , $books{$_}{count};
    }
    print "\n";
  }
  
  if ( $max_auth && $max_auth > 1 ) {
    printf "Most books by a single author: %d by %s\n" ,
      $max_auth_count , $max_auth->author;
  }
}


1; # Magic true value required at end of module

__END__

=head1 NAME

Booklist::Cmd::Command::authors - list all authors from database

=head1 SYNOPSIS

Start reading a book



    booklist start --title $TITLE --author $AUTHOR --pages $PAGES [ --startedate $YYYYMMDD ]

    booklist start -t $TITLE -a $AUTHOR -p $PAGES [ -d $YYYYMMDD ]

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
