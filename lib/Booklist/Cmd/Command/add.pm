package Booklist::Cmd::Command::add;

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
    [ 'title|t=s'           , 'book title (required)'                   ] , 
    [ 'author|a=s@'         , 'book author (required; can be multiple)' ] , 
    [ 'pages|p=s'           , 'book page count (required)'              ] ,
    [ ] ,
    [ 'tag|T=s@'            , 'tags/categories to apply to this book (optional, can be multiple)' ] ,
  );
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;

  foreach my $var ( qw/ title author pages / ) {
    $self->usage_error( "$var is a required option" )
      unless $opt->{$var};
  }

}


sub run {
  my( $self , $opt , $args ) = @_;

  my $book  = Booklist->add_book( $opt );
  my $title = $book->title;

  
  my $db = Booklist->db_handle();
  
  my $reading_count = $db->resultset('Reading')->find({
    book       => $book->id ,
    finishdate => undef ,
  });
  
  if ( $reading_count ) {
    my $msg;
    
    if ( $reading_count->startdate ) {
      my $start = $reading_count->start_as_ymd();
      $msg = <<EOL;
You seem to already be reading that book.
You started it on $start and have not yet recorded a finish date.
Use 'booklist finish --title "$title"' to finish this reading.
EOL
    }
    else {
      my $added = $book->added_as_ymd();
      $msg = <<EOL;
You have already planned to read that book.
You added it to your list on $added and have not yet started reading.
Use 'booklist start --title "$title"' to start reading this book.
EOL
    }
    
    print STDERR $msg;
    
    exit(1);
    
  }
  
  my $reading = $db->resultset('Reading')->create( {
    book       => $book->id ,
    startdate  => undef     ,
    finishdate => undef     ,
  } );

  print "Added '$title' to read later\n";
}


1; # Magic true value required at end of module

__END__

=head1 NAME

Booklist::Cmd::Command::start - add a book to read later

=head1 SYNOPSIS

    booklist add --title $TITLE --author $AUTHOR --pages $PAGES [ --tag $TAG ]
    booklist add -t $TITLE -a $AUTHOR -p $PAGES [ -T $TAG ]

Multiple authors and tags can either be given as multiple arguments (e.g., C<< -a $AUTHOR1 -a $AUTHOR2 >>) or as comma-delimited (e.g., C<< -T $TAG1,$TAG2 >>)


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
