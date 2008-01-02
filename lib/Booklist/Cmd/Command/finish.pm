package Booklist::Cmd::Command::finish;

# $Id$
# $URL$

use warnings;
use strict;

use base qw/ App::Cmd::Command /;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Booklist;

sub opt_spec {
  (
    [ 'title|t=s'             , 'book title (required)'      , { required => 1 } ] ,
    [ ] ,
    [ 'finishdate|finish|d=s' , 'date finished reading (optional; defaults to today)' ] ,
  );
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;
  
  if ( $opt->{finishdate} ) {
    eval {
      $opt->{finishdate} = Booklist::ymd2epoch( $opt->{finishdate} ); 
    };
    $self->usage_error( $@ ) if ( $@ );
  }
}


sub run {
  my( $self , $opt , $args ) = @_;

  my $db = Booklist->db_handle();

  my $book = $db->resultset('Book')->find( {
    title => $opt->{title}
  } );

  unless ( $book ) {
    print STDERR "Hmm. I can't seem to find a book with that title...";
    exit(1);
  }

  my $reading = $db->resultset('Reading')->find({ 
    book       => $book->id ,
    finishdate => undef , 
  });

  unless ( $reading ) {
    print STDERR "You don't seem to be currently reading a book with that title...";
    exit(1);
  }

  my $finishdate;
  if ( $opt->{finishdate} ) {
    $finishdate = $opt->{finishdate};
  }
  else {
    $finishdate = time();
  }
  
  $reading->finishdate( $finishdate );
  
  $reading->update();

  my $title = $book->title;

  my $start    = DateTime->from_epoch( epoch => $reading->startdate()  );
  my $finish   = DateTime->from_epoch( epoch => $reading->finishdate() );
  my $duration = $finish - $start;
  
  my( $mo , $dy ) = $duration->in_units( 'months' , 'days'  );

  my $dys = 's';
  $dys = '' if $dy == 1;
    
  if ( $mo ) {
    my $mos = '';
    $mos = 's' if $mo > 1;

    $duration = sprintf "Read for %d month%s, %d day%s\n" , $mo , $mos , $dy , $dys;
  }
  else {
    $duration = sprintf "Read for %d day%s\n" , $dy , $dys; 
  }
  
  print "Finished reading '$title'\n$duration";
  exit;
}


1; # Magic true value required at end of module

__END__

=head1 NAME

Booklist::Cmd::start - start reading a book

=head1 SYNOPSIS

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
